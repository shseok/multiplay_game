import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/client_data_provider.dart';
import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';
import '../views/ozQuiz.dart';
import '../views/scoreboard.dart';
import '../views/tictactoe_board.dart';
import '../views/waiting_lobby.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';

  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.startGameListener(context);
    _socketMethods.updatePlayersStateListener(context);
    _socketMethods.pointIncreaseListener(context);
    _socketMethods.endGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    print('grame_screen building...');
    return WaitingLobby();
  }
}
