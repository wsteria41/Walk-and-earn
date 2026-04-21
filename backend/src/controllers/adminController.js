const adminService = require("../services/adminService");

async function getAdminDashboard(req, res) {
  try {
    const result = await adminService.getAdminDashboard();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getWeeklyStats(req, res) {
  try {
    const result = await adminService.getWeeklyStats();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getAllUsers(req, res) {
  try {
    const result = await adminService.getAllUsers(req.query.search);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getUserDetail(req, res) {
  try {
    const result = await adminService.getUserDetail(req.params.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getAllTransactions(req, res) {
  try {
    const result = await adminService.getAllTransactions();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getSuspicious(req, res) {
  try {
    const result = await adminService.getSuspicious();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function approveSuspicious(req, res) {
  try {
    const result = await adminService.approveSuspicious(req.params.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function rejectSuspicious(req, res) {
  try {
    const result = await adminService.rejectSuspicious(req.params.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getMerchants(req, res) {
  try {
    const result = await adminService.getMerchants();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function toggleMerchant(req, res) {
  try {
    const result = await adminService.toggleMerchant(req.params.id);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  getAdminDashboard,
  getWeeklyStats,
  getAllUsers,
  getUserDetail,
  getAllTransactions,
  getSuspicious,
  approveSuspicious,
  rejectSuspicious,
  getMerchants,
  toggleMerchant
};