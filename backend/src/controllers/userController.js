const { uploadFile } = require("../services/spacesUpload");
const userService = require("../services/userService");

async function getWeeklyLeaderboard(req, res) {
  try {
    const result = await userService.getWeeklyLeaderboard();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getMyWeeklyRank(req, res) {
  try {
    const userId = req.user.id;
    const result = await userService.getMyWeeklyRank(userId);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function getLeaderboard(req, res) {
  try {
    const result = await userService.getLeaderboard();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getDailyStats(req, res) {
  try {
    const userId = req.user.id;
    const days = Number(req.query.days) || 7;

    const result = await userService.getDailyStats(userId, days);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getDashboard(req, res) {
  try {
    const userId = req.user.id;
    const data = await userService.getUserDashboard(userId);
    res.status(200).json(data);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to load dashboard" });
  }
}

async function updateGoal(req, res) {
  try {
    const userId = req.user.id;
    const { goal } = req.body;

    const result = await userService.updateGoal(userId, goal);
    res.json(result);
  } catch (err) {
    console.error("GOAL UPDATE ERROR:", err);
    res.status(500).json({ error: err.message });
  }
}

async function getProfile(req, res) {
  try {
    const userId = req.user.id;
    const user = await userService.getUserProfile(userId);
    res.json(user);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
}

async function updateProfile(req, res) {
  try {
    const userId = req.user.id;
    const { name, phone, location } = req.body;

    await userService.updateProfile(userId, name, phone, location);
    res.json({ message: "Profile updated" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
}

async function updateHealth(req, res) {
  try {
    const userId = req.user.id;
    const { age, height, weight, birth_year } = req.body;

    await userService.updateHealth(userId, age, height, weight, birth_year);
    res.json({ message: "Health updated" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
}

async function getTotalStats(req, res) {
  try {
    const userId = req.user.id;
    const result = await userService.getTotalStats(userId);
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
}

async function uploadPhoto(req, res) {
  try {

    console.log("FILE:", req.file);

    const userId = req.user.id;

    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const photoUrl = await uploadFile(req.file, req.user.id);

    console.log("UPLOADED URL:", photoUrl);

    await userService.updateProfilePhoto(userId, photoUrl);

    res.json({
      message: "Photo uploaded",
      photo: photoUrl
    });

  } catch (error) {
    console.error("UPLOAD ERROR:", error);
    res.status(500).json({ message: "Photo upload failed" });
  }
}

module.exports = {
  getWeeklyLeaderboard,
  getMyWeeklyRank,
  getLeaderboard,
  getDailyStats,
  getDashboard,
  updateGoal,
  getProfile,
  updateProfile,
  updateHealth,
  getTotalStats,
  uploadPhoto
};