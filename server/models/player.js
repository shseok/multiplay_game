const mongoose = require("mongoose");

const playerSchema = new mongoose.Schema({
  nickname: {
    type: String,
    trim: true, // '     현    석   ' 방지
  },
  socketID: {
    type: String,
  },
  points: {
    type: Number,
    default: 0, // 플레이어 점수
  },
  playerType: { // O or X
    required: true, // ? 
    type: String,
  },
  isPartyLeader: {
    type: Boolean,
    default: false,
  }
});

module.exports = playerSchema;