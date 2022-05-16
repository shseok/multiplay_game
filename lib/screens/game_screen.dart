import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_game/screens/quiz_screen.dart';
// import 'package:provider/provider.dart';

import '../provider/client_data_provider.dart';
import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';
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
  // final SocketMethods _socketMethods = SocketMethods();

  // @override
  // void initState() {
  //   super.initState();
  //   _socketMethods.updateRoomListener(context);
  //   _socketMethods.updateTimer(context);
  //   _socketMethods.updatePlayersStateListener(context);
  //   _socketMethods.pointIncreaseListener(context);
  //   _socketMethods.endGameListener(context);
  // }

  /* riverpod 적용시 문제점
  1. 처음 방생성 후 3번의 rendering
  2. 준비 시간 5초 -> 5번의 rendering
  3. 라운드 당 시간 10초 -> 10번의 rendering...


   */
  @override
  Widget build(BuildContext context) {
    // RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    // final clientStateProvider = Provider.of<ClientDataProvider>(context);

    final size = MediaQuery.of(context).size;
    // print(size.height);

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            ref
                .watch(socketMethodsProvider.notifier)
                .updateRoomListener(context);
            ref
                .watch(socketMethodsProvider.notifier)
                .updatePlayersStateListener(context);
            // 포인트, 엔드게임 적용하기
            final roomStateProvider = ref.watch(roomDataProvider);
            print('game data in game screen => $roomStateProvider');
            print('${roomStateProvider.runtimeType}');
            return roomStateProvider['isJoin']
                ? WaitingLobby(roomStateProvider: roomStateProvider)
                : SafeArea(child: QuizScreen(roomStateProvider: roomStateProvider));
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //         '1라운드'
            //     ),
            //     Text('문제'),
            //     Text('정답'),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         const Scoreboard(),
            //       ],
            //     ),
            //     // const TicTacToeBoard(),
            //     Text(
            //         '나 : ${roomStateProvider['turn']['nickname']}'),
            //   ],
            // ),
          },
        ),
      ),
    );
  }
}
