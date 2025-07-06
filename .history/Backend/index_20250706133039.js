const http = require("http");
const app = require("./src/config/express.config");

const httpServer = http.createServer(app);
const PORT = 9008;
const host = "0.0.0.0"; // Allows access from other devices on the same network

httpServer.listen(PORT, host, (err) => {
  if (err) {
    console.error("Error starting server:", err);
    return;
  }

  // You might need to dynamically find the local IP or configure it
  const localIP = "192.168.1.131"; 
  console.log(`Server is running on port: ${PORT}`);
  console.log(`Local access: http://localhost:${PORT}`);
  console.log(`Network access: http://${localIP}:${PORT}`);
});
