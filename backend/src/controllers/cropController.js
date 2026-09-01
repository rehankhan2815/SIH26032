const pool = require("../config/db");

// GET all crops
const getCrops = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT *
       FROM crops
       ORDER BY crop_id`
    );

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch crops",
    });
  }
};

// GET crop by ID
const getCropById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT *
       FROM crops
       WHERE crop_id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Crop not found",
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch crop",
    });
  }
};

// CREATE crop
const createCrop = async (req, res) => {
  try {
    const { crop_name, crop_code, unit } = req.body;

    if (!crop_name || !crop_code || !unit) {
      return res.status(400).json({
        success: false,
        message: "crop_name, crop_code and unit are required",
      });
    }

    const result = await pool.query(
      `INSERT INTO crops
       (crop_name, crop_code, unit, is_active)
       VALUES ($1, $2, $3, TRUE)
       RETURNING *`,
      [crop_name, crop_code, unit]
    );

    res.status(201).json({
      success: true,
      message: "Crop created successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);

    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        message: "Crop already exists",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to create crop",
    });
  }
};

// UPDATE crop
const updateCrop = async (req, res) => {
  try {
    const { id } = req.params;
    const { crop_name, crop_code, unit } = req.body;

    const result = await pool.query(
      `UPDATE crops
       SET crop_name = $1,
           crop_code = $2,
           unit = $3
       WHERE crop_id = $4
       RETURNING *`,
      [crop_name, crop_code, unit, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Crop not found",
      });
    }

    res.json({
      success: true,
      message: "Crop updated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);

    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        message: "Crop code already exists",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to update crop",
    });
  }
};

// DEACTIVATE crop
const deactivateCrop = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `UPDATE crops
       SET is_active = FALSE
       WHERE crop_id = $1
       RETURNING *`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Crop not found",
      });
    }

    res.json({
      success: true,
      message: "Crop deactivated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to deactivate crop",
    });
  }
};

module.exports = {
  getCrops,
  getCropById,
  createCrop,
  updateCrop,
  deactivateCrop,
};