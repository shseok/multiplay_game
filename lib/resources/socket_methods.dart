import 'package:flutter/material.dart';
import 'package:mp_game/provider/client_data_provider.dart';
import 'package:mp_game/resources/socket_client.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../provider/room_data_provider.dart';
import '../screens/game_screen.dart';
import '../screens/quiz_screen.dart';
import '../utils/utils.dart';
import 'game_methods.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit('joinRoom', {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  // playerId를 주고 server에서 leader를 찾으라는 방식 / 하지만 여기서 nickname을 주고 찾으라고 할 수도 있겠다.
  void startReadyTimer(String roomId, String playerId) {
    _socketClient.emit('readyTimer', {
      'roomId': roomId,
      'playerId': playerId,
    });
  }

  void startGameTimer(String roomId) {
    _socketClient.emit("gameTimer", {
      'roomId': roomId,
    });
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void handleOSubmit(String answer, String roomId) {
    _socketClient.emit("ox", {'answer': answer, 'roomId': roomId}); // o
  }

  void handleXSubmit(String answer, String roomId) {
    _socketClient.emit("ox", {'answer': answer, 'roomId': roomId}); // x
  }

  void updateRound(int curRound, String roomId){
    _socketClient.emit("round", {'curRound': curRound, 'roomId': roomId});
  }
  // LISTENERS ----------------------------------------------------------------------
  void createRoomSuccessListener(BuildContext context) {
    print('listen createRoomSuccessListener in socket_methods');
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void updateRoomListener(BuildContext context) {
    // createRoomSuccessListener와 비슷하지만 navigator x
    print('listen updateRoomListener in socket_methods');
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void updateReadyTimer(BuildContext context) {
    print('listen updateReadyTimer in socket_methods');
    _socketClient.on('readyTimer', (data) {
      Provider.of<ClientDataProvider>(context, listen: false)
          .setClientState(data);
    });
  }

  void updateStartTimer(BuildContext context) {
    print('listen updateStartTimer in socket_methods');
    _socketClient.on('gameTimer', (data) {
      Provider.of<ClientDataProvider>(context, listen: false)
          .setClientState(data);
    });
  }

  void startGameListener(BuildContext context) {
    print('listen startgame in socket_methods');
    _socketClient.on('startGame', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
      Provider.of<ClientDataProvider>(context, listen: false).setClientState({'countDown': 10, 'msg': '남은 시간'});
      Navigator.pushNamed(context, QuizScreen.routeName);
    });
  }

  // void tappedListener(BuildContext context) {
  //   _socketClient.on('tapped', (data) {
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

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}
