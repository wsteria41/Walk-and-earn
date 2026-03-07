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

module.exports = {
  getAdminDashboard
};