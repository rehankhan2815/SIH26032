const pool = require("../config/db");

// GET all slots with optional filtering
const getSlots = async (req, res) => {
  try {
    const { center_id, crop_id, date } = req.query;
    let query = `SELECT s.*, c.center_name, cr.crop_name 
                 FROM procurement_slots s
                 JOIN procurement_centers c ON s.center_id = c.center_id
                 JOIN crops cr ON s.crop_id = cr.crop_id
                 WHERE s.is_active = TRUE`;
    const params = [];

    if (center_id) {
      params.push(center_id);
      query += ` AND s.center_id = $${params.length}`;
    }

    if (crop_id) {
      params.push(crop_id);
      query += ` AND s.crop_id = $${params.length}`;
    }

    if (date) {
      params.push(date);
      query += ` AND s.slot_date = $${params.length}`;
    }

    query += ` ORDER BY s.slot_date, s.start_time`;

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch slots",
    });
  }
};

// GET available slots (capacity > booked_count)
const getAvailableSlots = async (req, res) => {
  try {
    const { center_id, crop_id, date } = req.query;
    
    let query = `SELECT s.*, c.center_name, cr.crop_name 
                 FROM procurement_slots s
                 JOIN procurement_centers c ON s.center_id = c.center_id
                 JOIN crops cr ON s.crop_id = cr.crop_id
                 WHERE s.is_active = TRUE AND s.booked_count < s.capacity`;
    const params = [];

    if (center_id) {
      params.push(center_id);
      query += ` AND s.center_id = $${params.length}`;
    }

    if (crop_id) {
      params.push(crop_id);
      query += ` AND s.crop_id = $${params.length}`;
    }

    if (date) {
      params.push(date);
      query += ` AND s.slot_date = $${params.length}`;
    }

    query += ` ORDER BY s.slot_date, s.start_time`;

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch available slots",
    });
  }
};

// GET slot by ID
const getSlotById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT s.*, c.center_name, cr.crop_name 
       FROM procurement_slots s
       JOIN procurement_centers c ON s.center_id = c.center_id
       JOIN crops cr ON s.crop_id = cr.crop_id
       WHERE s.slot_id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Slot not found",
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
      message: "Failed to fetch slot",
    });
  }
};

// CREATE slot
const createSlot = async (req, res) => {
  try {
    const {
      center_id,
      crop_id,
      slot_date,
      start_time,
      end_time,
      capacity,
    } = req.body;

    if (!center_id || !crop_id || !slot_date || !start_time || !end_time || !capacity) {
      return res.status(400).json({
        success: false,
        message: "Required slot details are missing",
      });
    }

    const result = await pool.query(
      `INSERT INTO procurement_slots
       (center_id, crop_id, slot_date, start_time, end_time, capacity)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [center_id, crop_id, slot_date, start_time, end_time, capacity]
    );

    res.status(201).json({
      success: true,
      message: "Slot created successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to create slot",
    });
  }
};

// UPDATE slot
const updateSlot = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      center_id,
      crop_id,
      slot_date,
      start_time,
      end_time,
      capacity,
      is_active
    } = req.body;

    const result = await pool.query(
      `UPDATE procurement_slots
       SET center_id = COALESCE($1, center_id),
           crop_id = COALESCE($2, crop_id),
           slot_date = COALESCE($3, slot_date),
           start_time = COALESCE($4, start_time),
           end_time = COALESCE($5, end_time),
           capacity = COALESCE($6, capacity),
           is_active = COALESCE($7, is_active)
       WHERE slot_id = $8
       RETURNING *`,
      [center_id, crop_id, slot_date, start_time, end_time, capacity, is_active, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Slot not found",
      });
    }

    res.json({
      success: true,
      message: "Slot updated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to update slot",
    });
  }
};

// DELETE (Deactivate) slot
const deactivateSlot = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `UPDATE procurement_slots
       SET is_active = FALSE
       WHERE slot_id = $1
       RETURNING *`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Slot not found",
      });
    }

    res.json({
      success: true,
      message: "Slot deactivated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Failed to deactivate slot",
    });
  }
};

module.exports = {
  getSlots,
  getAvailableSlots,
  getSlotById,
  createSlot,
  updateSlot,
  deactivateSlot,
};