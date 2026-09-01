const pool = require("../config/db");

/**
 * Service to handle commodity price logic.
 * In a real scenario, this would fetch from data.gov.in or Agmarknet.
 * For this implementation, we provide a sync function that can be called 
 * to "fetch" latest prices (mocked for now) and save them to our DB.
 */

const fetchLatestPrices = async (crop_id, district, state) => {
  // Mock external API response
  // In reality: const response = await axios.get('https://api.data.gov.in/resource/...')
  
  const mockPrices = [
    {
      crop_id: crop_id || 1,
      market_name: "Local Mandi",
      district: district || "Dewas",
      state: state || "Madhya Pradesh",
      price_date: new Date().toISOString().split('T')[0],
      min_price: 2100.00,
      max_price: 2450.00,
      modal_price: 2300.00,
      source: "Mock Agmarknet"
    }
  ];

  return mockPrices;
};

const syncPrices = async (crop_id, district, state) => {
  const prices = await fetchLatestPrices(crop_id, district, state);
  
  const savedPrices = [];
  for (const price of prices) {
    const result = await pool.query(
      `INSERT INTO commodity_prices 
       (crop_id, market_name, district, state, price_date, min_price, max_price, modal_price, source)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [
        price.crop_id,
        price.market_name,
        price.district,
        price.state,
        price.price_date,
        price.min_price,
        price.max_price,
        price.modal_price,
        price.source
      ]
    );
    savedPrices.push(result.rows[0]);
  }
  
  return savedPrices;
};

module.exports = {
  fetchLatestPrices,
  syncPrices
};