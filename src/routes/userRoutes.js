const express= require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const userController = require("../controllers/userController");

router.get("/leaderboard/weekly", authMiddleware, userController.getWeeklyLeaderboard);
router.get("/leaderboard/weekly/me", authMiddleware, userController.getMyWeeklyRank);
router.get("/leaderboard", authMiddleware, userController.getLeaderboard);
router.get("/stats/daily", authMiddleware, userController.getDailyStats);

module.exports = router;