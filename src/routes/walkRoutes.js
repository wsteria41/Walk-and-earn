const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const walkController = require("../controllers/walkController");

router.post("/submit", authMiddleware, walkController.submitSteps);
router.get("/history", authMiddleware, walkController.getHistory);
router.get("/daily-summary", authMiddleware, walkController.getDailySummary);

module.exports = router;