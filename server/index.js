const express = require('express');
const http = require('http');
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);

var io = require('socket.io')(server);

// middleware
app.use(express.json());

const DB = "mongodb+srv://hyeon:test123@cluster0.se3yt.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

io.on('connection', (socket) => {
    console.log('connection event: connected!');
});

mongoose.connect(DB).then(() => {
    console.log('Connection successful!');
})
    .catch((e) => {
        console.log(e);
    });

server.listen(port, '0.0.0.0', () => {
    console.log(`listening on port ${port}`);
});