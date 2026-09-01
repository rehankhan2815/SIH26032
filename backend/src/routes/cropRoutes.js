const express = require("express");

const {
  getCrops,
  getCropById,
  createCrop,
  updateCrop,
  deactivateCrop,
} = require("../controllers/cropController");

const router = express.Router();

router.get("/", getCrops);
router.get("/:id", getCropById);
router.post("/", createCrop);
router.put("/:id", updateCrop);
router.delete("/:id", deactivateCrop);

module.exports = router;