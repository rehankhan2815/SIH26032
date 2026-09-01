const express = require("express");

const {
  getCenters,
  getCenterById,
  createCenter,
  updateCenter,
  deactivateCenter,
} = require("../controllers/centerController");

const router = express.Router();

router.get("/", getCenters);
router.get("/:id", getCenterById);
router.post("/", createCenter);
router.put("/:id", updateCenter);
router.delete("/:id", deactivateCenter);

module.exports = router;