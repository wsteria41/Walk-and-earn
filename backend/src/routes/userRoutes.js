const express= require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const userController = require("../controllers/userController");
const pool = require("../config/db");

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM users");
    res.json(rows);
  } catch (err) {
    console.error("DB ERROR:", err);   
    res.status(500).json({ error: err.message });
  }
});
router.get("/leaderboard/weekly", authMiddleware, userController.getWeeklyLeaderboard);
router.get("/leaderboard/weekly/me", authMiddleware, userController.getMyWeeklyRank);
router.get("/leaderboard", authMiddleware, userController.getLeaderboard);
router.get("/stats/daily", authMiddleware, userController.getDailyStats);
router.get("/dashboard", authMiddleware, userController.getDashboard);
router.get("/stats/total", authMiddleware, userController.getTotalStats);
router.post("/goal", authMiddleware, userController.updateGoal);
router.get("/profile", authMiddleware, userController.getProfile);
router.put("/profile", authMiddleware, userController.updateProfile);
router.put("/health", authMiddleware, userController.updateHealth);

module.exports = router;