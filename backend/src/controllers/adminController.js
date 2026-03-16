const adminService = require("../services/adminService");

async function getAdminDashboard(req, res) {
  try {
    const result = await adminService.getAdminDashboard();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getAllUsers(req, res) {
  try {
    const result = await adminService.getAllUsers();
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

module.exports = {
  getAdminDashboard,
  getAllUsers,
  getAllTransactions
};