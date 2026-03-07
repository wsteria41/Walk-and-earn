const authService = require("../services/authService");

async function register(req, res) {
  try {
    const { email, password } = req.body;
    const result = await authService.register(email, password);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function login(req, res) {
  try {
    console.log("LOGIN BODY:", req.body);

    const { email, password } = req.body;

    if (!email || !password) {
      throw new Error("Email or password missing");
    }

    const result = await authService.login(email, password);
    res.json(result);

  } catch (err) {
    console.error("LOGIN ERROR:", err);
    res.status(400).json({ error: err.message || "Unknown error" });
  }
}

module.exports = { register, login };