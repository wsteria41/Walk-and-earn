const express = require("express");
const router = express.Router();
const multer = require("multer"); 
const upload = multer({ storage: multer.memoryStorage() }); 

const authMiddleware = require("../middlewares/authMiddleware");
const roleMiddleware = require("../middlewares/roleMiddleware");
const rewardController = require("../controllers/rewardController");

router.post("/create", authMiddleware, roleMiddleware("MERCHANT"), rewardController.createReward);
router.post("/redeem/:rewardId", authMiddleware, rewardController.redeemReward);
router.post("/approve/:transactionId", authMiddleware, roleMiddleware("MERCHANT"), rewardController.approveRedemption);
router.post("/reject/:transactionId", authMiddleware, roleMiddleware("MERCHANT"), rewardController.rejectRedemption);

router.post(
  "/upload-image",
  authMiddleware,
  roleMiddleware("MERCHANT"),
  upload.single("image"),
  rewardController.uploadRewardPhoto
);

router.get("/admin/suspicious", authMiddleware, roleMiddleware("ADMIN"), rewardController.getSuspiciousUsers);
router.get("/list", authMiddleware, rewardController.getRewardList);
router.get("/my-redemptions", authMiddleware, rewardController.getMyRedemptions);
router.get("/my-rewards", authMiddleware, roleMiddleware("MERCHANT"), rewardController.getMyRewards);
router.get("/pending-redemptions", authMiddleware, roleMiddleware("MERCHANT"), rewardController.getPendingRedemptions);
router.get("/merchant-stats", authMiddleware, roleMiddleware("MERCHANT"), rewardController.getMerchantStats);

module.exports = router;