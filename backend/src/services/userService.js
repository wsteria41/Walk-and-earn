const pool = require("../config/db");

//Level tootsoolol
function calculateLevel(totalPoints) {
  if (totalPoints >= 5000) return 5;
  if (totalPoints >= 2000) return 4;
  if (totalPoints >= 1000) return 3;
  if (totalPoints >= 500)  return 2;
  return 1;
}

async function getLeaderboard() {
  const [rows] = await pool.query(`
    SELECT id, name, email, total_points
    FROM users
    WHERE role = 'USER'
    ORDER BY total_points DESC
    LIMIT 10
  `);
  return { leaderboard: rows };
}

async function getWeeklyLeaderboard() {
  const [rows] = await pool.query(`
    SELECT 
      ranked.id,
      ranked.name,
      ranked.email,
      ranked.weekly_steps,
      ranked.weekly_points,
      ranked.rank_position
    FROM (
      SELECT 
        u.id,
        u.name,
        u.email,
        SUM(sr.delta_steps) AS weekly_steps,
        FLOOR(SUM(sr.delta_steps) / 1000) AS weekly_points,
        RANK() OVER (ORDER BY SUM(sr.delta_steps) DESC) AS rank_position
      FROM users u
      JOIN step_records sr ON u.id = sr.user_id
      WHERE sr.recorded_at >= CURDATE() - INTERVAL 7 DAY
        AND u.role = 'USER'
      GROUP BY u.id
    ) AS ranked
    ORDER BY ranked.rank_position
    LIMIT 10
  `);
  return { weeklyLeaderboard: rows };
}

async function getMyWeeklyRank(userId) {
  const [myStepsRows] = await pool.query(
    `SELECT IFNULL(SUM(delta_steps), 0) AS my_weekly_steps
     FROM step_records
     WHERE user_id = ?
       AND recorded_at >= CURDATE() - INTERVAL 7 DAY`,
    [userId]
  );
  const myWeeklySteps = Number(myStepsRows[0].my_weekly_steps);

  const [rankRows] = await pool.query(
    `SELECT COUNT(*) + 1 AS my_rank
     FROM (
       SELECT user_id, SUM(delta_steps) AS total_steps
       FROM step_records
       WHERE recorded_at >= CURDATE() - INTERVAL 7 DAY
       GROUP BY user_id
     ) AS weekly_totals
     WHERE weekly_totals.total_steps > ?`,
    [myWeeklySteps]
  );

  return { myWeeklySteps, myRank: rankRows[0].my_rank };
}

async function getDailyStats(userId, days = 7) {
  const [rows] = await pool.query(
    `SELECT 
       DATE(recorded_at) AS date,
       MAX(delta_steps) AS steps,
       FLOOR(SUM(CASE WHEN suspicious_flag = 0 THEN delta_steps ELSE 0 END) / 1000) AS points
     FROM step_records
     WHERE user_id = ?
       AND recorded_at >= CURDATE() - INTERVAL ? DAY
     GROUP BY DATE(recorded_at)`,
    [userId, days]
  );

  const dataMap = {};
  rows.forEach(r => {
    const formattedDate = r.date.toISOString().split("T")[0];
    dataMap[formattedDate] = {
      steps: Number(r.steps) || 0,
      points: Number(r.points) || 0
    };
  });

  const result = [];
  const today = new Date();
  for (let i = days - 1; i >= 0; i--) {
    const d = new Date();
    d.setDate(today.getDate() - i);
    const dateStr = d.toISOString().split("T")[0];
    result.push({
      date: dateStr,
      steps: dataMap[dateStr]?.steps || 0,
      points: dataMap[dateStr]?.points || 0
    });
  }

  return { dailyStats: result };
}

async function getUserDashboard(userId) {
  const [userRows] = await pool.query(
    `SELECT id, name, email, total_points, daily_goal, profile_photo
     FROM users WHERE id = ?`,
    [userId]
  );

  if (!userRows.length) throw new Error("User not found");
  const user = userRows[0];

  const [todayRows] = await pool.query(
    `SELECT total_steps
    FROM step_records
    WHERE user_id = ?
    AND DATE(recorded_at) = CURDATE()
    ORDER BY recorded_at DESC
    LIMIT 1`,
    [userId]
  );

  const todaySteps =
    todayRows.length > 0
      ? Number(todayRows[0].total_steps)
      : 0;

  const [weeklyRows] = await pool.query(
    `SELECT IFNULL(SUM(delta_steps), 0) AS weekly_steps
     FROM step_records
     WHERE user_id = ?
       AND recorded_at >= CURDATE() - INTERVAL 7 DAY`,
    [userId]
  );
  const weeklySteps = Number(weeklyRows[0].weekly_steps);

  // suspicius alhmiig hasna
  const [ptRows] = await pool.query(
    `SELECT IFNULL(SUM(delta_steps), 0) AS valid_steps
     FROM step_records
     WHERE user_id = ?
       AND DATE(recorded_at) = CURDATE()
       AND suspicious_flag = 0`,
    [userId]
  );
  const todayPoints = Math.floor(Number(ptRows[0].valid_steps) / 1000);

  return {
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      totalPoints: user.total_points,
      level: calculateLevel(user.total_points), 
      dailyGoal: user.daily_goal,
      profile_photo: user.profile_photo
    },
    todaySteps,
    weeklySteps,
    todayPoints
  };
}

async function updateGoal(userId, goal) {
  await pool.query(
    `UPDATE users SET daily_goal = ? WHERE id = ?`,
    [goal, userId]
  );
  return { message: "Goal updated" };
}

async function getUserProfile(userId) {
  const [rows] = await pool.query(
    `SELECT id, name, email, phone, location, profile_photo,
            total_points, age, height, weight, birth_year, bmi
     FROM users WHERE id = ?`,
    [userId]
  );

  if (!rows.length) return null;

  const user = rows[0];

  //Level DB ees bish tootsoolj butsaana 
  return {
    ...user,
    level: calculateLevel(user.total_points)
  };
}

async function updateProfile(userId, name, phone, location) {
  await pool.query(
    `UPDATE users SET name=?, phone=?, location=? WHERE id=?`,
    [name, phone, location, userId]
  );
}

async function updateHealth(userId, age, height, weight, birth_year) {
  const bmi = weight / ((height / 100) * (height / 100));
  await pool.query(
    `UPDATE users SET age=?, height=?, weight=?, birth_year=?, bmi=? WHERE id=?`,
    [age, height, weight, birth_year, bmi.toFixed(2), userId]
  );
}

async function getTotalStats(userId) {
  const [rows] = await pool.query(
    `SELECT 
       IFNULL(SUM(delta_steps), 0) AS totalSteps,
       FLOOR(IFNULL(SUM(CASE WHEN suspicious_flag = 0 THEN delta_steps ELSE 0 END), 0) / 1000) AS rewards,
       COUNT(DISTINCT DATE(recorded_at)) AS activeDays
     FROM step_records
     WHERE user_id = ?`,
    [userId]
  );
  return rows[0];
}

async function updateProfilePhoto(userId, photoUrl) {
  await pool.query(
    `UPDATE users SET profile_photo = ? WHERE id = ?`,
    [photoUrl, userId]
  );
}

module.exports = {
  getWeeklyLeaderboard,
  getMyWeeklyRank,
  getLeaderboard,
  getUserDashboard,
  getDailyStats,
  updateGoal,
  getUserProfile,
  updateProfile,
  updateHealth,
  getTotalStats,
  updateProfilePhoto
};