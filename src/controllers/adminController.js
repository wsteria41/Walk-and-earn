const adminService = require("../services/adminService");

async function getAdminDashboard(req, res) {
  try {
    const result = await adminService.getAdminDashboard();
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  getAdminDashboard
};