import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_game/provider/client_data_provider.dart';
import 'package:mp_game/provider/player_data_provider.dart';
import 'package:mp_game/resources/socket_client.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../provider/room_data_provider.dart';
import '../screens/game_screen.dart';
import '../utils/utils.dart';
import 'game_methods.dart';

final socketMethodsProvider = StateNotifierProvider<SocketMethods, SocketClient>((ref) {
  return SocketMethods(ref);
});


class SocketMethods extends StateNotifier<SocketClient>{
  final ref;
  SocketMethods(this.ref) : super(SocketClient.instance);
  // final _socketClient = SocketClient.instance.socket!;
  //
  // Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      state.socket!.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      state.socket!.emit('joinRoom', {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      state.socket!.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  // playerId를 주고 server에서 leader를 찾으라는 방식 / 하지만 여기서 nickname을 주고 찾으라고 할 수도 있겠다.
  void startTimer(String roomId, String playerId) {
    state.socket!.emit('timer', {
      'roomId': roomId,
      'playerId': playerId,
    });
  }

  // LISTENERS
  void createRoomSuccessListener(BuildContext context) {
    state.socket!.on('createRoomSuccess', (room) {
      // Provider.of<RoomDataProvider>(context, listen: false).updateRoomData(room);
      ref.read(roomDataProvider.notifier).updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    state.socket!.on('joinRoomSuccess', (room) {
      // Provider.of<RoomDataProvider>(context, listen: false).updateRoomData(room);
      ref.read(roomDataProvider.notifier).updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    state.socket!.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) { // player_data_provier에서 players list로 변경시 적용하기
    state.socket!.on('updatePlayers', (playerData) {
      // Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(playerData[0]);
      // Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(playerData[1]);
      ref.read(playerDataProvider.notifier).updatePlayer(playerData);
    });
  }

  void updateRoomListener(BuildContext context) {
    // createRoomSuccessListener와 비슷하지만 navigator x
    state.socket!.on('updateRoom', (data) {
      // Provider.of<RoomDataProvider>(context, listen: false).updateRoomData(data);
      ref.read(roomDataProvider.notifier).updateRoomData(data);
    });
  }

  void updateTimer(BuildContext context) {
    state.socket!.on('timer', (data) {
      // Provider.of<ClientDataProvider>(context, listen: false).setClientState(data);
      ref.read(clientDataProvider.notifier).setClientState(data);
    });
  }

  // void tappedListener(BuildContext context) {
  //   state.socket!.on('tapped', (data) {
  //     RoomDataProvider roomDataProvider =
  //         Provider.of<RoomDataProvider>(context, listen: false);
  //     roomDataProvider.updateDisplayElements(
  //       data['index'],
  //       data['choice'],
  //     );
  //     roomDataProvider.updateRoomData(data['room']);
  //     // check winnner
  //     GameMethods().checkWinner(context, _socketClient);
  //   });
  // }
  //
  // void pointIncreaseListener(BuildContext context) {
  //   state.socket!.on('pointIncrease', (playerData) {
  //     var roomDataProvider =
  //         Provider.of<RoomDataProvider>(context, listen: false);
  //     if (playerData['socketID'] == roomDataProvider.player1.socketID) {
  //       roomDataProvider.updatePlayer1(playerData);
  //     } else {
  //       roomDataProvider.updatePlayer2(playerData);
  //     }
  //   });
  // }
  //
  // void endGameListener(BuildContext context) {
  //   state.socket!.on('endGame', (playerData) {
  //     showGameDialog(context, '${playerData['nickname']} won the game!');
  //     Navigator.popUntil(context, (route) => false);
  //   });
  // }
}
