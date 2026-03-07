const rewardService = require("../services/rewardService");

async function redeemReward(req, res) { 
  // 1. User ID авах (authMiddleware-аас)
  try {
    const userId = req.user.id;
    const rewardId = req.params.rewardId;

    const result = await rewardService.redeemReward(userId, rewardId);

    res.json(result);

  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function getSuspiciousUsers(req, res) {
  try {
    const result = await rewardService.getSuspiciousUsers();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function createReward(req, res) {
  try {
    const userId = req.user.id;
    const { name, description, required_points, stock_limit } = req.body;

    const result = await rewardService.createReward(
      userId,
      name,
      description,
      required_points,
      stock_limit
    );

    res.status(201).json(result);

  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function approveRedemption(req, res) {
try{
  const merchantUserId = req.user.id;
  const transactionId = req.params.transactionId;

  const result = await rewardService.approveRedemption(
    merchantUserId,
    transactionId
  );

  res.json(result);
  }catch(err){
    res.status(400).json({error: err.message});
  }
}

async function rejectRedemption(req, res){
  try{
    const merchantUserId = req.user.id;
    const transactionId = req.params.transactionId;

    const result = await rewardService.rejectRedemption(
      merchantUserId,
      transactionId
    );
    
    res.json(result);
  }catch(err){
      res.status(400).json({error: err.message});
    }
}

async function getMyRedemptions(req, res) {
  try {
    const userId = req.user.id;
    const result = await rewardService.getMyRedemptions(userId);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
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