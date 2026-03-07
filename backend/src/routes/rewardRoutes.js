const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const roleMiddleware = require("../middlewares/roleMiddleware");
const rewardController = require("../controllers/rewardController");

router.post(
  "/create",
  authMiddleware,
  roleMiddleware("MERCHANT"),
  rewardController.createReward
);

router.post(
  "/redeem/:rewardId", 
  authMiddleware,
  rewardController.redeemReward
);

router.post(
  "/approve/:transactionId", //merchant нь зөвшөөрөх боломжтой байх
  authMiddleware,
  roleMiddleware("MERCHANT"),
  rewardController.approveRedemption
);

router.post(
  "/reject/:transactionId", //merchant нь буцаах боломжтой байх
  authMiddleware,
  roleMiddleware("MERCHANT"),
  rewardController.rejectRedemption
);

router.get(
  "/admin/suspicious",
  authMiddleware,
  roleMiddleware("ADMIN"),
  rewardController.getSuspiciousUsers
);


module.exports = router;