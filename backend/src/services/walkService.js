const pool = require("../config/db");

function calculateDistance(lat1, lon1, lat2, lon2) {

  const R = 6371; 
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) *
    Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) *
    Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

async function submitSteps(userId, totalSteps, latitude, longitude, timestamp = new Date()) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    // last record
    const [lastRows] = await connection.query(
      `SELECT total_steps, recorded_at, latitude, longitude
       FROM step_records
       WHERE user_id = ?
       ORDER BY recorded_at DESC
       LIMIT 1`,
      [userId]
    );

    let previousTotal = 0;
    let previousTime = null;
    let previousLat = null;
    let previousLon = null;

    if (lastRows.length > 0) {
      previousTotal = lastRows[0].total_steps;
      previousTime = new Date(lastRows[0].recorded_at);
      previousLat = lastRows[0].latitude;
      previousLon = lastRows[0].longitude;
    }

    let delta = totalSteps - previousTotal;

    let suspicious = 0;
    let reason = null;

    // Counter reset detection
    if (delta < 0) {
      delta = 0;
    }

    // Sudden jump detection
    if (delta > 5000) {
      suspicious = 1;
      reason = "Sudden step jump";
      delta = 0;
    }

    // 5 minute spike detection
    if (previousTime) {

      const minutesDiff =
        (new Date(timestamp) - previousTime) / (1000 * 60);

      if (minutesDiff <= 5 && delta > 1500) {
        suspicious = 1;
        reason = "Unrealistic spike in 5 minutes";
        delta = 0;
      }

    }

    // Daily limit detection
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

    // SPEED DETECTION
    if (previousLat && previousLon && previousTime) {

      const distanceKm = calculateDistance(
        previousLat,
        previousLon,
        latitude,
        longitude
      );

      const hours =
        (new Date(timestamp) - previousTime) / (1000 * 60 * 60);

      if (hours > 0) {

        const speed = distanceKm / hours;

        if (speed > 15) {
          suspicious = 1;
          reason = "Unrealistic walking speed";
          delta = 0;
        }

      }

    }

    //GPS SPOOF DETECTION 
    if (previousLat != null && previousLon != null) {

      const distance = calculateDistance(
        previousLat,
        previousLon,
        latitude,
        longitude
      );

      if (distance > 2 && delta > 200) {
        suspicious = 1;
        reason = "GPS spoof detected";
        delta = 0;
      }

    }

    //PATTERN DETECTION
    const [patternRows] = await connection.query(
      `SELECT delta_steps
       FROM step_records
       WHERE user_id = ?
       ORDER BY recorded_at DESC
       LIMIT 10`,
      [userId]
    );

    if (patternRows.length >= 5) {

      const values = patternRows.map(r => r.delta_steps);

      values.push(delta);

      const max = Math.max(...values);
      const min = Math.min(...values);

      const variance = max - min;

      if (variance < 5 && max > 20) {
        suspicious = 1;
        reason = "Suspicious step pattern";
        delta = 0;
      }

    }

    //Save record
    await connection.query(
      `INSERT INTO step_records
       (user_id, total_steps, delta_steps, suspicious_flag, suspicion_reason, latitude, longitude, recorded_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, totalSteps, delta, suspicious, reason, latitude, longitude, timestamp]
    );

    //Points logic
    let pointsEarned = 0;

    if (!suspicious && delta > 0) {

      const [userRows] = await connection.query(
        `SELECT pending_steps
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

async function syncSteps(userId, totalSteps, latitude, longitude) {

  const result = await submitSteps(
    userId,
    totalSteps,
    latitude,
    longitude
  );

  return {
    previousSteps: result.previousTotal,
    newSteps: result.newTotal,
    deltaSteps: result.deltaSteps,
    pointsEarned: result.pointsEarned,
    suspicious: result.suspicious
  };

}

async function getHistory(userId, days = 7) {

  const [rows] = await pool.query(
    `SELECT 
        DATE(recorded_at) AS date,
        MAX(total_steps) AS steps,
        FLOOR(SUM(delta_steps) / 1000) AS points
     FROM step_records
     WHERE user_id = ?
     GROUP BY DATE(recorded_at)
     ORDER BY date DESC
     LIMIT ?`,
    [userId, days]
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
  syncSteps,
  submitSteps,
  getHistory,
  getDailySummary
};