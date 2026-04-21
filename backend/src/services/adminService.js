const pool = require("../config/db");

async function getAdminDashboard() {//admin dashboard data aggregation
  const [users] = await pool.query(`
    SELECT COUNT(*) AS total_users FROM users
  `);

  const [steps] = await pool.query(`
    SELECT IFNULL(SUM(delta_steps),0) AS total_steps FROM step_records
  `);

  const [points] = await pool.query(`
    SELECT IFNULL(SUM(total_points),0) AS total_points FROM users
  `);

  const [redeems] = await pool.query(`
    SELECT COUNT(*) AS total_redeems FROM redeem_transactions
  `);

  const [pending] = await pool.query(`
    SELECT COUNT(*) AS pending_redeems 
    FROM redeem_transactions
    WHERE status = 'PENDING'
  `);

  const [suspicious] = await pool.query(`
    SELECT COUNT(*) AS suspicious_count
    FROM step_records
    WHERE suspicious_flag = 1
  `);

  const [dailyActive] = await pool.query(`
    SELECT 
      DATE(recorded_at) AS date,
      COUNT(DISTINCT user_id) AS active_users
    FROM step_records
    WHERE recorded_at >= CURDATE() - INTERVAL 7 DAY
    GROUP BY DATE(recorded_at)
    ORDER BY DATE(recorded_at)
  `);

  return {
    totalUsers: users[0].total_users,
    totalSteps: Number(steps[0].total_steps),
    totalPoints: Number(points[0].total_points),
    totalRedeems: redeems[0].total_redeems,
    pendingRedeems: pending[0].pending_redeems,
    suspiciousRecords: suspicious[0].suspicious_count,
    dailyActiveUsers: dailyActive.map(r => ({
      date: r.date.toISOString().split("T")[0],
      activeUsers: r.active_users
    }))
  };
}

async function getAllUsers() {
  const [rows] = await pool.query(`
    SELECT id, name, email, role, total_points, daily_goal, created_at
    FROM users
    WHERE role = 'USER'
    ORDER BY created_at DESC
  `);
  return { users: rows };
}

async function getAllTransactions() {
  const [rows] = await pool.query(`
    SELECT t.id, t.status, t.points_used, t.redeemed_at,
           u.name AS user_name, u.email AS user_email,
           r.name AS reward_name
    FROM redeem_transactions t
    JOIN users u ON t.user_id = u.id
    JOIN rewards r ON t.reward_id = r.id
    ORDER BY t.redeemed_at DESC
  `);
  return { transactions: rows };
}


// WEEKLY STATS
async function getWeeklyStats() {
  const [rows] = await pool.query(`
    SELECT
      DATE(recorded_at) AS date,
      COUNT(DISTINCT user_id) AS active_users,
      SUM(CASE WHEN suspicious_flag=0 THEN delta_steps ELSE 0 END) AS valid_steps,
      FLOOR(SUM(CASE WHEN suspicious_flag=0 THEN delta_steps ELSE 0 END)/1000) AS points_earned
    FROM step_records
    WHERE recorded_at >= CURDATE() - INTERVAL 7 DAY
    GROUP BY DATE(recorded_at)
    ORDER BY date ASC
  `);

  return { weeklyStats: rows };
}


// USER DETAIL
async function getUserDetail(userId) {

  const [[user]] = await pool.query(
    `SELECT id, name, email, total_points, daily_goal, created_at
     FROM users WHERE id=? AND role='USER'`,
    [userId]
  );

  if (!user) throw new Error("User not found");


  const [history] = await pool.query(`
    SELECT
      DATE(recorded_at) AS date,
      SUM(delta_steps) AS steps,
      FLOOR(SUM(CASE WHEN suspicious_flag=0 THEN delta_steps ELSE 0 END)/1000) AS points,
      SUM(CASE WHEN suspicious_flag=1 THEN 1 ELSE 0 END) AS suspicious_count
    FROM step_records
    WHERE user_id=?
    GROUP BY DATE(recorded_at)
    ORDER BY date DESC
    LIMIT 7
  `, [userId]);


  const [redeems] = await pool.query(`
    SELECT rt.id, r.name, rt.points_used, rt.status, rt.redeemed_at
    FROM redeem_transactions rt
    JOIN rewards r ON rt.reward_id = r.id
    WHERE rt.user_id=?
    ORDER BY rt.redeemed_at DESC
    LIMIT 5
  `, [userId]);

  return { user, history, redeems };

}


// SUSPICIOUS LIST
async function getSuspicious() {

  const [rows] = await pool.query(`
    SELECT sr.id, sr.user_id, u.email, sr.total_steps,
           sr.delta_steps, sr.suspicion_reason, sr.recorded_at,
           sr.reviewed
    FROM step_records sr
    JOIN users u ON sr.user_id = u.id
    WHERE sr.suspicious_flag = 1
    ORDER BY sr.recorded_at DESC
  `);

  return { suspicious: rows };

}


// APPROVE SUSPICIOUS
async function approveSuspicious(recordId) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    const [[record]] = await connection.query(
      `SELECT user_id, delta_steps FROM step_records WHERE id=?`,
      [recordId]
    );

    if (!record) throw new Error("Not found");


    await connection.query(
      `UPDATE step_records
       SET suspicious_flag=0, reviewed=1
       WHERE id=?`,
      [recordId]
    );


    const pointsEarned = Math.floor(record.delta_steps / 1000);

    if (pointsEarned > 0) {

      await connection.query(
        `UPDATE users
         SET total_points = total_points + ?
         WHERE id=?`,
        [pointsEarned, record.user_id]
      );

    }

    await connection.commit();

    return {
      message: "Approved",
      pointsAdded: pointsEarned
    };

  } catch (err) {

    await connection.rollback();
    throw err;

  } finally {

    connection.release();

  }

}


// REJECT SUSPICIOUS
async function rejectSuspicious(recordId) {

  await pool.query(
    `UPDATE step_records
     SET reviewed=1
     WHERE id=?`,
    [recordId]
  );

  return { message: "Rejected" };

}


// MERCHANT LIST
async function getMerchants() {

  const [rows] = await pool.query(`
    SELECT id, name, email, is_active, created_at,
           (SELECT COUNT(*)
            FROM rewards
            WHERE merchant_id=users.id) AS reward_count
    FROM users
    WHERE role='MERCHANT'
    ORDER BY created_at DESC
  `);

  return { merchants: rows };

}


// TOGGLE MERCHANT
async function toggleMerchant(merchantId) {

  const [[merchant]] = await pool.query(
    `SELECT is_active
     FROM users
     WHERE id=? AND role='MERCHANT'`,
    [merchantId]
  );

  if (!merchant) throw new Error("Not found");


  const newStatus = merchant.is_active ? 0 : 1;


  await pool.query(
    `UPDATE users
     SET is_active=?
     WHERE id=?`,
    [newStatus, merchantId]
  );


  return {
    message: newStatus ? "Activated" : "Deactivated",
    is_active: newStatus
  };

}


module.exports = {
  getAdminDashboard,
  getAllUsers,
  getAllTransactions,
  getWeeklyStats,
  getUserDetail,
  getSuspicious,
  approveSuspicious,
  rejectSuspicious,
  getMerchants,
  toggleMerchant
};

