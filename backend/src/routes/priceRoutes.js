const express = require("express");
const { getPrices, syncPrices } = require("../controllers/priceController");

const router = express.Router();

router.get("/", getPrices);
router.post("/sync", syncPrices);

module.exports = router;