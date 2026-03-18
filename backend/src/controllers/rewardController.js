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
    const { name, description, required_points, stock_limit,
            discount_percent, reward_type, image_url } = req.body;

    const result = await rewardService.createReward(
      userId, name, description, required_points, stock_limit,
      discount_percent, reward_type, image_url
    );
    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function uploadRewardPhoto(req, res) {
  try {
    const file = req.file;
    if (!file) return res.status(400).json({ error: "Файл байхгүй" });

    const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
    const s3 = new S3Client({
      endpoint: process.env.DO_SPACE_ENDPOINT,       
      region: "sgp1",
      credentials: {
        accessKeyId: process.env.DO_SPACE_KEY,        
        secretAccessKey: process.env.DO_SPACE_SECRET, 
      },
    });

    const key = `rewards/${Date.now()}-${file.originalname}`;
    await s3.send(new PutObjectCommand({
      Bucket: process.env.DO_SPACE_BUCKET,            
      Key: key,
      Body: file.buffer,
      ContentType: file.mimetype,
      ACL: "public-read",
    }));

    const url = `https://${process.env.DO_SPACE_BUCKET}.sgp1.digitaloceanspaces.com/${key}`;
    res.json({ url });
  } catch (err) {
    res.status(500).json({ error: err.message });
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

async function getRewardList(req, res) {
  try {
    const result = await rewardService.getRewardList();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getMyRewards(req, res) {
  try {
    const result = await rewardService.getMyRewards(req.user.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getPendingRedemptions(req, res) {
  try {
    const result = await rewardService.getPendingRedemptions(req.user.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getMerchantStats(req, res) {
  try {
    const result = await rewardService.getMerchantStats(req.user.id);
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
  rejectRedemption,
  getRewardList,
  getMyRewards,
  getMerchantStats,
  getPendingRedemptions,
  uploadRewardPhoto
};