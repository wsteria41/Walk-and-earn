const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/authMiddleware");
const walkController = require("../controllers/walkController");

router.post("/submit", authMiddleware, walkController.submitSteps);
router.get("/history", authMiddleware, walkController.getHistory);
router.get("/daily-summary", authMiddleware, walkController.getDailySummary);
router.post("/sync", authMiddleware, walkController.syncSteps);

module.exports = router;
