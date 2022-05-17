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

const questions = [
	{ id: 1, oxQuestion: "이 앱의 이름은 다모여이다.", oxAnswer: "o", explanation: "이 앱의 이름은 다모여가 맞다." },
	{ id: 2, oxQuestion: "이 앱을 만든 조의 이름은 BOOM이다", oxAnswer: "x", explanation: "이 앱을 만든 조의 이름은 BOM이다." },
	{ id: 3, oxQuestion: "이 앱을 만든 조는 6조이다.", oxAnswer: "o", explanation: "이 앱을 만든 조는 6조가 맞다." },
	{ id: 4, oxQuestion: "토마토는 과일이 아니라 채소이다.", oxAnswer: "o", explanation: "토마토는 채소이다." },
	{ id: 5, oxQuestion: "원숭이에게는 지문이 없다.", oxAnswer: "x", explanation: "원숭이에게도 지문이 있다." },
	{ id: 6, oxQuestion: "가장 강한 독을 가진 개구리 한마리의 독으로 사람 2000명 이상을 죽일 수 있다.", oxAnswer: "o", explanation: "아프리카에 사는 식인 개구리의 독성으로 2000명의 사람을 죽일 수 있다." },
	{ id: 7, oxQuestion: "달팽이는 이빨이 있다", oxAnswer: "o", explanation: "달팽이도 이빨이 있다." },
	{ id: 8, oxQuestion: "고양이는 잠을 잘 때 꿈을 꾼다", oxAnswer: "o", explanation: "고양이도 잠을 잘 때 꿈을 꾼다." },
	{ id: 9, oxQuestion: "물고기도 색을 구분할 수 있다.", oxAnswer: "o", explanation: "물고기도 색을 구분한다." },
	{ id: 10, oxQuestion: "낙지의 심장은 3개이다", oxAnswer: "o", explanation: "낙지의 심장은 3개이다." }
];

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
          playerType: "X", // 제거하기
          isPartyLeader: true,
          };
          room.players.push(player);
          questions.map((question) => room.questions.push(question));
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

      if (room.isJoin) { // 방의 인원이 다 차있지 않거나 시작되지 않았을 때
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        if (room.players.length >= room.occupancy) { // 가득 찬 경우 참여불가
          room.isJoin = false;
        }
        room = await room.save();
        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room); // waiting -> start로 화면을 업데이트 하기 위함
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
    
    socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);

      let choice = room.turn.playerType; // x or o
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      io.to(roomId).emit("tapped", {
        index,
        choice,
        room,
      });
    } catch (e) {
      console.log(e);
    }
    });
  
    socket.on("round", async ({ curRound, roomId }) => {
      try {
        let room = await Room.findById(roomId);
        room.currentRound = curRound;
        room = await room.save();
        io.to(roomId).emit("updateRoom", room);
        console.log(`${curRound}} 라운드가 저장되었습니다.`);
      } catch (e) {
        console.log(e);
      }
    });
      
    socket.on("ox", async ({answer, roomId}) => {
      try {
        let room = await Room.findById(roomId);
        let player = room.players.find(
            (playerr) => playerr.socketID == socket.id
        );
        player.points += 1; // round의 문제의 정답과 answer가 같아야함
        room = await room.save();
        io.to(roomId).emit("pointIncrease", player);
        console.log(`${player.nickname} : ${socket.id} == ${player.socketID} => ${answer}`);
      } catch {
        console.log(e);
      }
    });

    socket.on("winner", async ({ winnerSocketId, roomId }) => {
      try {
        let room = await Room.findById(roomId);
        let player = room.players.find(
          (playerr) => playerr.socketID == winnerSocketId
        );
        player.points += 1;
        room = await room.save();

        if (player.points >= room.maxRounds) {
          io.to(roomId).emit("endGame", player);
        } else {
          io.to(roomId).emit("pointIncrease", player);
        }
      } catch (e) {
        console.log(e);
      }
    });

    socket.on("readyTimer", async ({ roomId, playerId }) => {
      let countDown = 5;
      console.log(`timer started! ${roomId} ${playerId} ${typeof(roomId)}`);
      let room = await Room.findById(roomId); // mongoose.Model.findById
      let player = room.players.id(playerId); // id 내장 함수??

      console.log(`readyTimer -> ${player}`);
      if (player.isPartyLeader) {
        let timerId = setInterval(async () => {
          if (countDown >= 0) {
            io.to(roomId).emit(
              "readyTimer", {
              countDown,
              msg: "게임 준비중..."
            }
            );
            console.log(countDown);
            countDown--;
          } else {
            console.log('게임을 시작합니다!'); //  참여불가
            room.isJoin = false;
            room = await room.save();
            io.to(roomId).emit("startGame", room);
            clearInterval(timerId);
          }
        }, 1000);
      } else {
        
      }
    });
    
    socket.on("gameTimer", async ({ roomId }) => {
      startGameClock(roomId);
    });
});

const startGameClock = (roomId) => {
  let time = 10;

  let timerId = setInterval(() => {
    if (time >= 0) {
      io.to(roomId).emit("gameTimer", {
        countDown: time,
        msg: "남은 시간",
      });
      console.log(time);
      time--;
    } else {
      clearInterval(timerId);
      }
  }, 1000);
}

mongoose.connect(DB).then(() => {
    console.log('Mongoose Connection successful!');
})
    .catch((e) => {
        console.log(e);
    });

server.listen(port, '0.0.0.0', () => {
    console.log(`listening on port ${port}`);
});