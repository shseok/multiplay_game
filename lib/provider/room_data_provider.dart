import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/room.dart';

class RoomDataProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};
  Map<String, dynamic> get roomData => _roomData;

  // GameRoomState _roomData = GameRoomState(
  //   id: '',
  //   players: [],
  //   isJoin: true,
  //   isOver: false,
  //   turnIndex: 0,
  //   maxRounds: 6,
  //   occupancy: 3,
  //   currentRound: 1,
  // );
  //
  // Map<String, dynamic> get roomData => _roomData.toJson();

  List<String> _displayElement = ['', '', '', '', '', '', '', '', ''];
  int _filledBoxes = 0;
  Player _player1 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 'X',
    isPartyLeader: false,
  );

  Player _player2 = Player(
      nickname: '',
      socketID: '',
      points: 0,
      playerType: 'O',
      isPartyLeader: false);

  List<String> get displayElements => _displayElement;

  int get filledBoxes => _filledBoxes;

  Player get player1 => _player1;

  Player get player2 => _player2;

  void updateRoomData(Map<String, dynamic> data) {
    // _roomData = GameRoomState.fromMap(data);
    _roomData = data;
    notifyListeners();
  }

  void updatePlayer1(Map<String, dynamic> player1Data) {
    _player1 = Player.fromMap(player1Data);
    notifyListeners();
  }

  void updatePlayer2(Map<String, dynamic> player2Data) {
    _player2 = Player.fromMap(player2Data);
    notifyListeners();
  }

  void updateDisplayElements(int index, String choice) {
    _displayElement[index] = choice;
    _filledBoxes += 1;
    notifyListeners();
  }

  void setFilledBoxesTo0() {
    _filledBoxes = 0;
  }
}
