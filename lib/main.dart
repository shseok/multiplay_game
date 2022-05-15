import 'package:flutter/material.dart';
import 'package:mp_game/provider/client_data_provider.dart';
import 'package:mp_game/provider/room_data_provider.dart';
import 'package:mp_game/screens/create_room_screen.dart';
import 'package:mp_game/screens/game_screen.dart';
import 'package:mp_game/screens/join_room_screen.dart';
import 'package:mp_game/screens/main_menu_screen.dart';
import 'package:mp_game/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>  RoomDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>  ClientDataProvider(),
        ),
      ],
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor, // 주석처리하는게 ㄱㅊ
      ),
      routes: {
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
        CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
        GameScreen.routeName: (context) => const GameScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
      home: MainMenuScreen(),
    ),
    );
  }
}