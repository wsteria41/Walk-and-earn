const express = require("express");
const pool = require("./config/db");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes");
const authMiddleware = require("./middlewares/authMiddleware");
const walkRoutes = require("./routes/walkRoutes");
const rewardRoutes = require("./routes/rewardRoutes");
const userRoutes = require("./routes/userRoutes");
const adminRoutes = require("./routes/adminRoutes");

const app = express();

app.use(express.json());

app.use("/auth", authRoutes);
app.use("/walk", walkRoutes);
app.use("/rewards", rewardRoutes);
app.use("/users", userRoutes);
app.use("/admin", adminRoutes);

app.get("/users", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM users");
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/test-db", async (req, res) => {
  const [rows] = await pool.query("SELECT 1");
  res.json({ message: "DB Connected", rows });
});

app.get("/me", authMiddleware, (req, res) => {
  res.json({
    message: "Protected route accessed",
    user: req.user
  });
});

module.exports = app;