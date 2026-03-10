const pool = require("../config/db");

async function redeemReward(userId, rewardId) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    const [rewardRows] = await connection.query(
      `SELECT * FROM rewards 
       WHERE id = ? AND is_active = 1 
       FOR UPDATE`,
      [rewardId]
    );

    if (rewardRows.length === 0) {
      throw new Error("Reward not available");
    }

    const reward = rewardRows[0];

    if (reward.remaining_stock <= 0) {
      throw new Error("Reward out of stock");
    }

    const [userRows] = await connection.query(
      `SELECT total_points 
       FROM users 
       WHERE id = ? 
       FOR UPDATE`,
      [userId]
    );

    if (userRows.length === 0) {
      throw new Error("User not found");
    }

    const userPoints = userRows[0].total_points;

    if (userPoints < reward.required_points) {
      throw new Error("Not enough points");
    }

    await connection.query(
      `UPDATE users 
       SET total_points = total_points - ? 
       WHERE id = ?`,
      [reward.required_points, userId]
    );

    await connection.query(
      `UPDATE rewards 
       SET remaining_stock = remaining_stock - 1 
       WHERE id = ?`,
      [rewardId]
    );

    await connection.query(
      `INSERT INTO redeem_transactions
       (user_id, reward_id, points_used, status, redeemed_at)
       VALUES (?, ?, ?, 'PENDING', NOW())`,
      [userId, rewardId, reward.required_points]
    );

    await connection.commit();

    return {
      message: "Redeem request submitted",
      status: "PENDING",
      pointsUsed: reward.required_points
    };

  } catch (err) {

    await connection.rollback();
    throw err;

  } finally {

    connection.release();

  }
}

async function getSuspiciousUsers() {

  const [rows] = await pool.query(
    `SELECT user_id, total_steps, delta_steps, suspicion_reason, recorded_at
     FROM step_records
     WHERE suspicious_flag = 1
     ORDER BY recorded_at DESC`
  );

  return { suspiciousRecords: rows };
}

async function createReward(userId, name, description, requiredPoints, stockLimit) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    const [merchantRows] = await connection.query(
      `SELECT id FROM merchants WHERE user_id = ?`,
      [userId]
    );

    if (merchantRows.length === 0) {
      throw new Error("Merchant profile not found");
    }

    const merchantId = merchantRows[0].id;

    await connection.query(
      `INSERT INTO rewards
       (merchant_id, name, description, required_points, stock_limit, remaining_stock, is_active, created_at)
       VALUES (?, ?, ?, ?, ?, ?, 1, NOW())`,
      [
        merchantId,
        name,
        description,
        requiredPoints,
        stockLimit,
        stockLimit
      ]
    );

    await connection.commit();

    return {
      message: "Reward created successfully"
    };

  } catch (err) {

    await connection.rollback();
    throw err;

  } finally {

    connection.release();

  }
}

async function getMyRedemptions(userId) {

  const [rows] = await pool.query(
    `SELECT r.name, t.points_used, t.status, t.redeemed_at
     FROM redeem_transactions t
     JOIN rewards r ON t.reward_id = r.id
     WHERE t.user_id = ?
     ORDER BY t.redeemed_at DESC`,
    [userId]
  );

  return { redemptions: rows };
}

async function approveRedemption(merchantUserId, transactionId) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    const [merchantRows] = await connection.query(
      `SELECT id FROM merchants WHERE user_id = ?`,
      [merchantUserId]
    );

    if (merchantRows.length === 0) {
      throw new Error("Merchant not found");
    }

    const merchantId = merchantRows[0].id;

    const [txRows] = await connection.query(
      `SELECT t.*, r.merchant_id
       FROM redeem_transactions t
       JOIN rewards r ON t.reward_id = r.id
       WHERE t.id = ? FOR UPDATE`,
      [transactionId]
    );

    if (txRows.length === 0) {
      throw new Error("Transaction not found");
    }

    const tx = txRows[0];

    if (tx.merchant_id !== merchantId) {
      throw new Error("Unauthorized action");
    }

    if (tx.status !== "PENDING") {
      throw new Error("Transaction already processed");
    }

    await connection.query(
      `UPDATE redeem_transactions 
       SET status = 'APPROVED' 
       WHERE id = ?`,
      [transactionId]
    );

    await connection.commit();

    return { message: "Redemption approved" };

  } catch (err) {

    await connection.rollback();
    throw err;

  } finally {

    connection.release();

  }
}

async function rejectRedemption(merchantUserId, transactionId) {

  const connection = await pool.getConnection();

  try {

    await connection.beginTransaction();

    const [merchantRows] = await connection.query(
      `SELECT id FROM merchants WHERE user_id = ?`,
      [merchantUserId]
    );

    if (merchantRows.length === 0) {
      throw new Error("Merchant not found");
    }

    const merchantId = merchantRows[0].id;

    const [txRows] = await connection.query(
      `SELECT t.*, r.merchant_id
       FROM redeem_transactions t
       JOIN rewards r ON t.reward_id = r.id
       WHERE t.id = ? FOR UPDATE`,
      [transactionId]
    );

    if (txRows.length === 0) {
      throw new Error("Transaction not found");
    }

    const tx = txRows[0];

    if (tx.merchant_id !== merchantId) {
      throw new Error("Unauthorized merchant");
    }

    if (tx.status !== "PENDING") {
      throw new Error("Transaction already processed");
    }

    await connection.query(
      `UPDATE redeem_transactions
       SET status = 'REJECTED'
       WHERE id = ?`,
      [transactionId]
    );

    await connection.query(
      `UPDATE users
       SET total_points = total_points + ?
       WHERE id = ?`,
      [tx.points_used, tx.user_id]
    );

    await connection.query(
      `UPDATE rewards
       SET remaining_stock = remaining_stock + 1
       WHERE id = ?`,
      [tx.reward_id]
    );

    await connection.commit();

    return { message: "Redemption rejected & points refunded" };

  } catch (err) {

    await connection.rollback();
    throw err;

  } finally {

    connection.release();

  }
}

module.exports = {
  redeemReward,
  getSuspiciousUsers,
  getMyRedemptions,
  createReward,
  approveRedemption,
  rejectRedemption
};