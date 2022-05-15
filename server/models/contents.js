const mongoose = require("mongoose");

const questionSchema = new mongoose.Schema({
  id: {
    type: Number,
  },
  oxQuestion: {
    type: String,
    default: '준비 중입니다',
  },
  oxAnswer: { // O or X
    required: true, // ? 
    type: String,
  },
  explanation: {
    type: String,
    default: '준비 중입니다',
  }
});

module.exports = questionSchema;