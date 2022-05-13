class RoomState {
  final String id;
  final List players;
  final bool isJoin;
  final bool isOver;
  final List words;
  final int occupancy;
  final int maxRounds;
  final int currentRound;
  final int turnIndex; // 삭제할 것

  RoomState({
    required this.id,
    required this.players,
    required this.isJoin,
    required this.words,
    required this.isOver,
    required this.occupancy,
    required this.maxRounds,
    required this.currentRound,
    required this.turnIndex,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'players': players,
        'isJoin': isJoin,
        'words': words,
        'isOver': isOver,
        'occupancy': occupancy,
        'maxRounds': maxRounds,
        'currentRound': currentRound,
        'turnIndex': turnIndex,
      };
}
