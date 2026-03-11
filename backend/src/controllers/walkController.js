const walkService = require("../services/walkService");

async function submitSteps(req, res) {
  try {
    const userId = req.user.id;
    const { total_steps } = req.body;

    if (!total_steps || total_steps < 0) {
      return res.status(400).json({
        message: "Invalid total_steps value"
      });
    }

    const result = await walkService.submitSteps(userId, total_steps);

    res.json(result);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getHistory(req, res) {
  try {
    const userId = req.user.id;
    const result = await walkService.getHistory(userId);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getDailySummary(req, res) {
  try {
    const userId = req.user.id;
    const result = await walkService.getDailySummary(userId);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.syncSteps = async (req, res) => {
  try {

    const userId = req.user.id;
    const { total_steps } = req.body;

    const result = await walkService.syncSteps(userId, total_steps);

    res.json({
      message: "Steps synced",
      ...result
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  submitSteps,
  getHistory,
  getDailySummary,
  syncSteps
};