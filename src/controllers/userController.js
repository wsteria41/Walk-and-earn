const { getLeaderboard } = require("../services/userService");
const userService = require("../services/userService");

async function getWeeklyLeaderboard(req, res) {//
    try{
        const result = await userService.getWeeklyLeaderboard();
        res.json(result);   
    }catch(err){
        res.status(500).json({error: err.message});
    }
}
async function getMyWeeklyRank(req, res) {//authMiddleware-аас userId-ийг авна
  try {
    const userId = req.user.id;
    const result = await userService.getMyWeeklyRank(userId);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getDailyStats(req, res) {//authMiddleware-аас userId-ийг авна, query parameter-аас days-ийг авна (default 7)
  try {
    const userId = req.user.id;
    const days = Number(req.query.days) || 7;

    const result = await userService.getDailyStats(userId, days);
    res.json(result);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
    getWeeklyLeaderboard,
    getMyWeeklyRank,
    getLeaderboard,
    getDailyStats
};