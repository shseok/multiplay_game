import 'package:flutter/material.dart';
import 'package:mp_game/resources/socket_methods.dart';
import 'package:mp_game/widgets/custom_button.dart';

class GameReadyButton extends StatefulWidget {
  const GameReadyButton({Key? key}) : super(key: key);

  @override
  State<GameReadyButton> createState() => _GameReadyButtonState();
}

class _GameReadyButtonState extends State<GameReadyButton> {
  final SocketMethods _socketMethods = SocketMethods();

  // findPlayerMe(){}
  //
  //
  // void handleStart(){
  //   _socketMethods.startTimer(roomId, playerId);
  // }

  @override
  Widget build(BuildContext context) {
    // final gameData = Provider.of<GameStateProvider>(context); // build function 안에 있으므로 listen: false X
    return CustomButton(onTap: (){}, text: '게임 시작');
  }
}
