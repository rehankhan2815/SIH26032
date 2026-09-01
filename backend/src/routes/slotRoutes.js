const express = require("express");
const {
  getSlots,
  getAvailableSlots,
  getSlotById,
  createSlot,
  updateSlot,
  deactivateSlot,
} = require("../controllers/slotController");

const router = express.Router();

router.get("/", getSlots);
router.get("/available", getAvailableSlots);
router.get("/:id", getSlotById);
router.post("/", createSlot);
router.put("/:id", updateSlot);
router.delete("/:id", deactivateSlot);

module.exports = router;