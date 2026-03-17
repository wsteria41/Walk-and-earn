const authService = require("../services/authService");

async function register(req, res) {
  try {
    const {name,  email, password } = req.body;
    const result = await authService.register(name, email, password);
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

    const result = await authService.login( email, password);
    res.json(result);

  } catch (err) {
    console.error("LOGIN ERROR:", err);
    res.status(400).json({ error: err.message || "Unknown error" });
  }
}

async function registerMerchant(req, res) {
  try {
    const { name, email, password, secret } = req.body;

    // Нууц код шалгах
    if (secret !== process.env.MERCHANT_SECRET) {
      return res.status(403).json({ error: "Нууц код буруу байна" });
    }

    const result = await authService.registerMerchant(name, email, password);
    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { register, login, registerMerchant};