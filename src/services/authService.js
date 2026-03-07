const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const pool = require("../config/db");

async function register(email, password) {
  const hashedPassword = await bcrypt.hash(password, 10);

  await pool.query(
    "INSERT INTO users (email, password_hash, total_points, role) VALUES (?, ?, 0, 'USER')",
    [email, hashedPassword]
  );

  return { message: "User registered" };
}

async function login(email, password) {
  console.log("LOGIN INPUT:", email, password);

  const [rows] = await pool.query(
    "SELECT * FROM users WHERE email = ?",
    [email]
  );

  console.log("DB RESULT:", rows);

  if (rows.length === 0) {
    throw new Error("User not found");
  }

  const user = rows[0];

  console.log("HASH VALUE:", user.password_hash);

  if (!user.password_hash) {
    throw new Error("Password hash missing in DB");
  }

  const isMatch = await bcrypt.compare(password, user.password_hash);

  console.log("COMPARE RESULT:", isMatch);

  if (!isMatch) {
    throw new Error("Invalid password");
  }

  const token = jwt.sign(
    { id: user.id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  return { token };
}

module.exports = { register, login };