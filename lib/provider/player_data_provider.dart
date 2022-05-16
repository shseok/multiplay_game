import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';

class PlayerNotifier extends StateNotifier<Player>{ // List<Player>로 바꾸기
  PlayerNotifier(): super(
      Player(
        nickname: '',
        socketID: '',
        points: 0,
        playerType: 'X',
        isPartyLeader: false,)
  );

  void updatePlayer(Map<String, dynamic> playerData) {
    state = Player.fromMap(playerData);
  }
}

final playerDataProvider = StateNotifierProvider<PlayerNotifier, Player>((ref){ // ref.watch(clientDataProvider).toJson()
  return PlayerNotifier();
});