const express = require('express');
const http = require('http');
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);

var io = require('socket.io')(server);

// middleware
app.use(express.json());
const Room = require('./models/room');

const DB = "mongodb+srv://hyeon:test123@cluster0.se3yt.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

io.on('connection', (socket) => {
    console.log('connection event: connected!');
    socket.on("createRoom", async ({ nickname }) => { 
        console.log('server create listen')
        try {
        // 방이 만들어진다.
        let room = new Room();
        let player = {
            socketID: socket.id,
            nickname,
            playerType: "X",
        };
        room.players.push(player);
        room.turn = player;
        room = await room.save(); // 몽고디비에 저장
        console.log(room);
        const roomId = room._id.toString(); // 저장된 몽고디비의 방을 불러오면 고유 _id를 얻을 수 있음
        
        socket.join(roomId); // 플레이어는 방에 저장된다. ( 다른 방에 접근 x 하도록. 즉, 메시지가 가지않도록)
        // io -> send data to everyone
        // socket -> sending data to yourself
        io.to(roomId).emit("createRoomSuccess", room); // 방에 있는 모든 사람들에게 전달
        } catch (e) {
            console.log(e);
        }
    });

    socket.on("joinRoom", async ({ nickname, roomId }) => {
        console.log('server join listen');   
    try {
        if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        console.log('check invalid Id ');
        socket.emit("errorOccurred", "Please enter a valid room ID.");
        return;
      }
      let room = await Room.findById(roomId); // mongo 내장함수

      if (room.isJoin) {
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        room.isJoin = false;
        room = await room.save();
        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room);
      } else {
        console.log('check The game is in progress');
        socket.emit(
          "errorOccurred",
          "The game is in progress, try again later."
        );
      }
    } catch (e) {
      console.log(e);
    }
  });
});

mongoose.connect(DB).then(() => {
    console.log('Mongoose Connection successful!');
})
    .catch((e) => {
        console.log(e);
    });

server.listen(port, '0.0.0.0', () => {
    console.log(`listening on port ${port}`);
});