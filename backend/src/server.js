const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());

const centerRoutes = require("./routes/centerRoutes");
const cropRoutes = require("./routes/cropRoutes");
const slotRoutes = require("./routes/slotRoutes");
const priceRoutes = require("./routes/priceRoutes");

app.use("/api/centers", centerRoutes);
app.use("/api/crops", cropRoutes);
app.use("/api/slots", slotRoutes);
app.use("/api/prices", priceRoutes);

app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "SIH26032 Backend is running",
  });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});