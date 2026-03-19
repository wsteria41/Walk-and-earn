const walkService = require("../services/walkService");

async function submitSteps(req, res) {
  try {
    const userId = req.user.id;
    const { totalSteps, total_steps, latitude, longitude } = req.body;
    const steps = totalSteps ?? total_steps;  

    if (steps === undefined || steps < 0) {
      return res.status(400).json({ message: "Invalid steps value" });
    }

    const result = await walkService.submitSteps(
      userId, steps, latitude, longitude
    );
    res.json(result);

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
}

async function syncSteps(req, res) {
  try {
    const userId = req.user.id;
    const { totalSteps, total_steps, latitude, longitude } = req.body;
    const steps = totalSteps ?? total_steps;  

    if (steps === undefined || steps < 0) {
      return res.status(400).json({ message: "Invalid steps value" });
    }

    const result = await walkService.syncSteps(
      userId, steps, latitude, longitude
    );
    res.json({ message: "Steps synced", ...result });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
}

async function getHistory(req, res) {
  try {
    const userId = req.user.id;
    const result = await walkService.getHistory(userId);
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
}

async function getDailySummary(req, res) {
  try {
    const userId = req.user.id;
    const result = await walkService.getDailySummary(userId);
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
}

module.exports = { submitSteps, syncSteps, getHistory, getDailySummary };