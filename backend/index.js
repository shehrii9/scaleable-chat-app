const express = require('express');
const cors = require('cors');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
const http = require('http');
const SocketController = require('./src/controllers/socket_controller');
const { Server } = require('socket.io');
const routes = require("./src/routes");

//init express
const app = express();
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

const PORT = process.env.PORT || 3000;

//create server
const server = http.createServer(app);

//initialize socket.io
const io = new Server(server, { cors: { origin: '*' } });
const socketController = new SocketController(io);
socketController.init();

app.use((req, res, next) => {
    req.socketId = socketController.socket.id;
    next();
});
app.use("/api", routes);
app.get("/", (req, res) => {
    console.log("new message");
    socketController.onMessage("", "NEW MESSAGE");
    res.json("sent");
})

server.listen(PORT, () => console.log(`Server is Running on PORT ${PORT}`));