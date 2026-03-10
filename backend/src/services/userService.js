const pool = require("../config/db");

async function getLeaderboard() {
  const [rows] = await pool.query(`
    SELECT id, email, total_points
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
      ranked.email,
      ranked.weekly_steps,
      ranked.weekly_points,
      ranked.rank_position
    FROM (
      SELECT 
        u.id,
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
  const [myStepsRows] = await pool.query(//user iin 7 honogiin niit alhalt
    `
    SELECT IFNULL(SUM(delta_steps), 0) AS my_weekly_steps
    FROM step_records
    WHERE user_id = ?
      AND recorded_at >= CURDATE() - INTERVAL 7 DAY
    `,
    [userId]
  );

  const myWeeklySteps = Number(myStepsRows[0].my_weekly_steps);

  const [rankRows] = await pool.query(//myWeeklySteps-ees iluu alhalt hiisen user uudiig toolno
    `
    SELECT COUNT(*) + 1 AS my_rank
    FROM (
      SELECT user_id, SUM(delta_steps) AS total_steps
      FROM step_records
      WHERE recorded_at >= CURDATE() - INTERVAL 7 DAY
      GROUP BY user_id
    ) AS weekly_totals
    WHERE weekly_totals.total_steps > ?
    `,
    [myWeeklySteps]
  );

  const myRank = rankRows[0].my_rank;

  return {
    myWeeklySteps,
    myRank
  };
}

async function getDailyStats(userId, days = 7) {//user iin suuliin N honogiin alhalt, onoog database aas avah
  const [rows] = await pool.query(
    `
    SELECT 
      DATE(recorded_at) AS date,
      SUM(delta_steps) AS steps,
      FLOOR(SUM(delta_steps) / 1000) AS points
    FROM step_records
    WHERE user_id = ?
      AND recorded_at >= CURDATE() - INTERVAL ? DAY
    GROUP BY DATE(recorded_at)
    `,
    [userId, days]
  );

  const dataMap = {}; //db ees irsen ogogdliig map bolgono
  rows.forEach(r => {
    const formattedDate = r.date.toISOString().split("T")[0];
    dataMap[formattedDate] = {
      steps: Number(r.steps) || 0,
      points: Number(r.points) || 0
    };
  });

  const result = []; //final result-g beltgene, hariu ni suuliin N honogiin ogogdliig aguulna
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

  /// USER PROFILE
  const [userRows] = await pool.query(
    `
    SELECT id, name, email, total_points
    FROM users
    WHERE id = ?
    `,
    [userId]
  );

  const user = userRows[0];

  /// TODAY STEPS
  const [todayRows] = await pool.query(
    `
    SELECT IFNULL(SUM(delta_steps),0) AS today_steps
    FROM step_records
    WHERE user_id = ?
    AND DATE(recorded_at) = CURDATE()
    `,
    [userId]
  );

  const todaySteps = Number(todayRows[0].today_steps);

  /// WEEKLY STEPS
  const [weeklyRows] = await pool.query(
    `
    SELECT IFNULL(SUM(delta_steps),0) AS weekly_steps
    FROM step_records
    WHERE user_id = ?
    AND recorded_at >= CURDATE() - INTERVAL 7 DAY
    `,
    [userId]
  );

  const weeklySteps = Number(weeklyRows[0].weekly_steps);

  const todayPoints = Math.floor(todaySteps / 1000);

  return {
    user: {
      id: user.id,
      email: user.email,
      totalPoints: user.total_points
    },
    todaySteps,
    weeklySteps,
    todayPoints
  };
}

module.exports = {
  getWeeklyLeaderboard,
  getMyWeeklyRank,
  getLeaderboard,
  getUserDashboard,
  getDailyStats
};