const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const roleMiddleware = require("../middlewares/roleMiddleware");
const adminController = require("../controllers/adminController");

const guard = [authMiddleware, roleMiddleware("ADMIN")];


// Dashboard KPI
router.get("/dashboard", ...guard, adminController.getAdminDashboard);

// Weekly stats chart
router.get("/stats/weekly", ...guard, adminController.getWeeklyStats);


// Users
router.get("/users", ...guard, adminController.getAllUsers);
router.get("/users/:id", ...guard, adminController.getUserDetail);


// Transactions
router.get("/transactions", ...guard, adminController.getAllTransactions);


// Suspicious detection
router.get("/suspicious", ...guard, adminController.getSuspicious);
router.put("/suspicious/:id/approve", ...guard, adminController.approveSuspicious);
router.put("/suspicious/:id/reject", ...guard, adminController.rejectSuspicious);


// Merchants
router.get("/merchants", ...guard, adminController.getMerchants);
router.put("/merchants/:id/toggle", ...guard, adminController.toggleMerchant);


module.exports = router;