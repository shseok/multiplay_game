import 'package:flutter/material.dart';
import 'package:mp_game/responsive/responsive.dart';
import 'package:mp_game/screens/join_room_screen.dart';
import '../widgets/custom_button.dart';
import 'create_room_screen.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';

  const MainMenuScreen({Key? key}) : super(key: key);

  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(onTap: () => createRoom(context), text: '방 생성'),
          const SizedBox(height: 20.0),
          CustomButton(onTap: () => joinRoom(context), text: '방 참여'),
        ],
      )),
    );
  }
}
