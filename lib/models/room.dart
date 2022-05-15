import 'package:mp_game/models/player.dart';

class GameRoomState {
  final String id;
  final List<dynamic> players;
  final bool isJoin;
  final bool isOver;
  final int occupancy;
  final int maxRounds;
  final int currentRound;
  final int turnIndex; // 삭제할 것

  GameRoomState({
    required this.id,
    required this.players,
    required this.isJoin,
    required this.isOver,
    required this.occupancy,
    required this.maxRounds,
    required this.currentRound,
    required this.turnIndex
  });

  Map<String, dynamic> toJson() => {
        '_id': id,
        'players': players,
        'isJoin': isJoin,
        'isOver': isOver,
        'occupancy': occupancy,
        'maxRounds': maxRounds,
        'currentRound': currentRound,
        'turnIndex': turnIndex,
      };

  factory GameRoomState.fromMap(Map<String, dynamic> map) {

    var list = map['players'] as List;
    List<dynamic> roomList = list.map((i) => Player.fromMap(i)).toList();
    print('$roomList ${roomList[0]} ${roomList[0].nickname}');
    return GameRoomState(
      id: map['_id'] ?? '',
      players: roomList,
      isJoin: map['isJoin'] ?? true,
      isOver: map['isOver'] ?? false,
      occupancy: map['occupancy'] ?? 0,
      turnIndex: map['turnIndex'] ?? 0,
      maxRounds: map['maxRounds'] ?? 0,
      currentRound: map['currentRound'] ?? 0
    );
  }
}
