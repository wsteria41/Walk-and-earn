const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const pool = require("../config/db");

async function register(name, email, password) {

  email = email.toLowerCase().trim();

  if (!name || !email || !password) {
    throw new Error("All fields are required");
  }

  if (password.length < 6) {
    throw new Error("Password must be at least 6 characters");
  }

  const [existing] = await pool.query(
    "SELECT id FROM users WHERE email = ?",
    [email]
  );

  if (existing.length > 0) {
    throw new Error("Email already registered");
  }


  const hashedPassword = await bcrypt.hash(password, 10);

  await pool.query(
    `INSERT INTO users 
      (name, email, password_hash, total_points, pending_steps, role)
     VALUES (?, ?, ?, 0, 0, 'USER')`,
    [name, email, hashedPassword]
  );

  return {
    message: "User registered successfully"
  };
}

async function login(email, password) {

  email = email.toLowerCase().trim();

  if (!email || !password) {
    throw new Error("Email and password required");
  }

  const [rows] = await pool.query(
    "SELECT id, name, email, password_hash, role FROM users WHERE email = ?",
    [email]
  );

  if (rows.length === 0) {
    throw new Error("Invalid email or password");
  }

  const user = rows[0];

  const validPassword = await bcrypt.compare(password, user.password_hash);

  if (!validPassword) {
    throw new Error("Invalid email or password");
  }

  // JWT token үүсгэх
  const token = jwt.sign(
    {
      id: user.id,
      role: user.role,
      email: user.email
    },
    process.env.JWT_SECRET,
    {
      expiresIn: "7d"
    }
  );

  return {
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email
    }
  };
}

module.exports = {
  register,
  login
};