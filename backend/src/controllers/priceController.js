const pool = require("../config/db");
const priceService = require("../services/priceService");

// GET all commodity prices with filtering
const getPrices = async (req, res) => {
  try {
    const { crop_id, district, state } = req.query;
    let query = `SELECT p.*, c.crop_name 
                 FROM commodity_prices p
                 JOIN crops c ON p.crop_id = c.crop_id
                 WHERE 1=1`;
    const params = [];

    if (crop_id) {
      params.push(crop_id);
      query += ` AND p.crop_id = $${params.length}`;
    }

    if (district) {
      params.push(district);
      query += ` AND p.district = $${params.length}`;
    }

    if (state) {
      params.push(state);
      query += ` AND p.state = $${params.length}`;
    }

    query += ` ORDER BY p.price_date DESC, p.fetched_at DESC`;

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch prices",
    });
  }
};

// POST sync prices from external source
const syncPrices = async (req, res) => {
  try {
    const { crop_id, district, state } = req.body;
    const syncedData = await priceService.syncPrices(crop_id, district, state);
    
    res.json({
      success: true,
      message: "Prices synced successfully",
      data: syncedData,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to sync prices",
    });
  }
};

module.exports = {
  getPrices,
  syncPrices,
};