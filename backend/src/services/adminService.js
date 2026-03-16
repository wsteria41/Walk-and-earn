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

module.exports = {
  getAdminDashboard,
  getAllUsers,
  getAllTransactions,
};

