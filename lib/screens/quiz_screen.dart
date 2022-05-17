import 'package:flutter/material.dart';
import 'package:mp_game/responsive/responsive.dart';
import 'package:provider/provider.dart';
import '../provider/client_data_provider.dart';
import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';
import '../views/ozQuiz.dart';

class QuizScreen extends StatefulWidget {
  static String routeName = '/quiz-room';

  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('quiz_screen building');
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    return Responsive(
        child: SafeArea(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background.png'), // 배경 이미지
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: OxQuiz(roomData: roomDataProvider.roomData)),
    )));
  }
}
