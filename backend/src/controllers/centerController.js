const pool = require("../config/db");

// GET all centers
const getCenters = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT *
       FROM procurement_centers
       ORDER BY center_id`
    );

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch centers",
    });
  }
};

// GET one center
const getCenterById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT *
       FROM procurement_centers
       WHERE center_id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Center not found",
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
      message: "Failed to fetch center",
    });
  }
};

// CREATE center
const createCenter = async (req, res) => {
  try {
    const {
      center_name,
      address,
      village,
      district,
      state,
      contact_phone,
      opening_time,
      closing_time,
    } = req.body;

    if (!center_name || !address || !village || !district || !state) {
      return res.status(400).json({
        success: false,
        message: "Required center details are missing",
      });
    }

    const result = await pool.query(
      `INSERT INTO procurement_centers
       (center_name, address, village, district, state,
        contact_phone, opening_time, closing_time)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
       RETURNING *`,
      [
        center_name,
        address,
        village,
        district,
        state,
        contact_phone,
        opening_time,
        closing_time,
      ]
    );

    res.status(201).json({
      success: true,
      message: "Center created successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to create center",
    });
  }
};

// UPDATE center
const updateCenter = async (req, res) => {
  try {
    const { id } = req.params;

    const {
      center_name,
      address,
      village,
      district,
      state,
      contact_phone,
      opening_time,
      closing_time,
    } = req.body;

    const result = await pool.query(
      `UPDATE procurement_centers
       SET center_name = $1,
           address = $2,
           village = $3,
           district = $4,
           state = $5,
           contact_phone = $6,
           opening_time = $7,
           closing_time = $8
       WHERE center_id = $9
       RETURNING *`,
      [
        center_name,
        address,
        village,
        district,
        state,
        contact_phone,
        opening_time,
        closing_time,
        id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Center not found",
      });
    }

    res.json({
      success: true,
      message: "Center updated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to update center",
    });
  }
};

// DEACTIVATE center
const deactivateCenter = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `UPDATE procurement_centers
       SET is_active = FALSE
       WHERE center_id = $1
       RETURNING *`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Center not found",
      });
    }

    res.json({
      success: true,
      message: "Center deactivated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to deactivate center",
    });
  }
};

module.exports = {
  getCenters,
  getCenterById,
  createCenter,
  updateCenter,
  deactivateCenter,
};