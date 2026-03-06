const pool = require("../config/db");

async function submitSteps(userId, totalSteps, timestamp = new Date()) {
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    //suulchiin bichleg avah
    const [lastRows] = await connection.query(
      `SELECT total_steps, recorded_at
       FROM step_records
       WHERE user_id = ?
       ORDER BY recorded_at DESC
       LIMIT 1`,
      [userId]
    );

    let previousTotal = 0;
    let previousTime = null;

    if (lastRows.length > 0) {
      previousTotal = lastRows[0].total_steps;
      previousTime = new Date(lastRows[0].recorded_at);
    }

    let delta = totalSteps - previousTotal;

    let suspicious = 0;
    let reason = null;

    if (delta < 0) {
      suspicious = 1;
      reason = "Step counter decreased (possible reset)";
      delta = 0; 
    }

    //5 minut tutamd 1500-aas deesh spike baival suspecious gej temdegleh
    if (previousTime) {
      const minutesDiff =
        (new Date(timestamp) - previousTime) / (1000 * 60);

      if (minutesDiff <= 5 && delta > 1500) {
        suspicious = 1;
        reason = "Unrealistic spike in 5 minutes";
        delta = 0;
      }
    }

    //Udriin niit alham 40000 aas ih bol suspecious gej temdegleh
    const [dailyRows] = await connection.query(
      `SELECT SUM(delta_steps) as daily_total
       FROM step_records
       WHERE user_id = ?
       AND recorded_at >= CURDATE()`,
      [userId]
    );

    const dailyTotal = (dailyRows[0].daily_total || 0) + delta;

    if (dailyTotal > 40000) {
      suspicious = 1;
      reason = "Daily step limit exceeded";
    }

    // step_records table-d record hiih
    await connection.query(
      `INSERT INTO step_records
       (user_id, total_steps, delta_steps, suspicious_flag, suspicion_reason, recorded_at)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [userId, totalSteps, delta, suspicious, reason, timestamp]
    );

    //onoo bodoh
    let pointsEarned = 0;

    if (!suspicious && delta > 0) {

      //  users.pending_steps avah
      const [userRows] = await connection.query(
        `SELECT pending_steps, total_points
         FROM users
         WHERE id = ?`,
        [userId]
      );

      const pendingSteps = userRows[0].pending_steps || 0;

      const totalPending = pendingSteps + delta;

      pointsEarned = Math.floor(totalPending / 1000);

      const remainingSteps = totalPending % 1000;

      await connection.query(
        `UPDATE users
         SET total_points = total_points + ?,
             pending_steps = ?
         WHERE id = ?`,
        [pointsEarned, remainingSteps, userId]
      );
    }

    await connection.commit();

    return {
      previousTotal,
      newTotal: totalSteps,
      deltaSteps: delta,
      dailyTotal,
      pointsEarned,
      suspicious,
      reason
    };

  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}


async function getHistory(userId) {
  const [rows] = await pool.query(
    `SELECT total_steps, delta_steps, suspicious_flag, recorded_at
     FROM step_records
     WHERE user_id = ?
     ORDER BY recorded_at DESC
     LIMIT 50`,
    [userId]
  );

  return {
    history: rows
  };
}

async function getDailySummary(userId) {
  const [rows] = await pool.query(
    `SELECT 
        SUM(delta_steps) as total_steps_today,
        SUM(CASE WHEN suspicious_flag = 0 THEN delta_steps ELSE 0 END) as valid_steps_today
     FROM step_records
     WHERE user_id = ?
     AND DATE(recorded_at) = CURDATE()`,
    [userId]
  );

  const totalSteps = rows[0].total_steps_today || 0;
  const validSteps = rows[0].valid_steps_today || 0;
  const pointsToday = Math.floor(validSteps / 1000);

  return {
    totalStepsToday: totalSteps,
    validStepsToday: validSteps,
    pointsToday
  };
}

module.exports = {
  submitSteps,
  getHistory,
  getDailySummary
};