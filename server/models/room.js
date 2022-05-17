const mongoose = require("mongoose");
const playerSchema = require("./player");
const questionSchema = require("./contents");

const roomSchema = new mongoose.Schema({
  occupancy: {
    type: Number,
    default: 3, // 방의 최대인원
  },
  maxRounds: {
    type: Number,
    default: 10, // 총 6라운드
  },
  currentRound: {
    required: true, // required ?
    type: Number,
    default: 1,
  },
  players: [playerSchema],
  isJoin: { // 게임시작시 들어가는 것을 방지하기 위함
    type: Boolean,
    default: true,
  },
  questions: [questionSchema],
  isOver: {
    type: Boolean,
    default: false,
  },
  turn: playerSchema, // 다른 유저의 차례
  turnIndex: { // 어느 사용자의 차례인지 추적하기 위함
    type: Number,
    default: 0,
  },
});

const roomModel = mongoose.model("Room", roomSchema);
module.exports = roomModel;