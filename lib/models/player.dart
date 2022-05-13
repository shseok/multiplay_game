class Player {
  final String nickname;
  final String socketID;
  final double points;
  final String playerType;
  final bool isPartyLeader;

  Player({
    required this.nickname,
    required this.socketID,
    required this.points,
    required this.playerType,
    required this.isPartyLeader,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'socketID': socketID, // player의 소켓 구분
      'points': points,
      'playerType': playerType,
      'isPartyLeader': isPartyLeader,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
        nickname: map['nickname'] ?? '',
        socketID: map['socketID'] ?? '',
        points: map['points']?.toDouble() ?? 0.0,
        playerType: map['playerType'] ?? '',
        isPartyLeader: map['isPartyLeader'] ?? false);
  }

  Player copyWith({
    String? nickname,
    String? socketID,
    double? points,
    String? playerType,
    bool? isPartyLeader,
  }) {
    return Player(
      nickname: nickname ?? this.nickname,
      socketID: socketID ?? this.socketID,
      points: points ?? this.points,
      playerType: playerType ?? this.playerType,
      isPartyLeader: isPartyLeader ?? this.isPartyLeader,
    );
  }
}
