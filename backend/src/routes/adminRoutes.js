const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");
const roleMiddleware = require("../middlewares/roleMiddleware");
const adminController = require("../controllers/adminController");

router.get(
  "/dashboard",
  authMiddleware,
  roleMiddleware("ADMIN"),
  adminController.getAdminDashboard
);
router.get("/users", authMiddleware, roleMiddleware("ADMIN"), adminController.getAllUsers);
router.get("/transactions", authMiddleware, roleMiddleware("ADMIN"), adminController.getAllTransactions);

module.exports = router;