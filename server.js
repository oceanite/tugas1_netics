const express = require("express");
const cors = require("cors");
const app = express();
const port = 5000;

app.use(cors());
// Store the start time when the server first runs
const startTime = new Date(); // Capture the start time

app.get("/health", (req, res) => {
  const currentTime = new Date();
  const uptime = (currentTime - startTime) / 1000; // Calculate uptime in seconds

  res.json({
    nama: "Beluga",
    nrp: "5025231040",
    status: "UP", // Server status
    timestamp: startTime.toLocaleString("id-ID", { timeZone: "Asia/Jakarta" }), // Server start time (doesn't change)
    uptime: `${Math.floor(uptime)} detik`, // Uptime increases dynamically
  });
});

// Start the server
const server = app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

// Handle server shutdown (optional: graceful shutdown)
process.on("SIGINT", () => {
  console.log("\nShutting down server...");
  server.close(() => {
    console.log("Server has stopped.");
    process.exit(0);
  });
});
