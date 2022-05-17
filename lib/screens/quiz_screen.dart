import 'dart:async';

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

  final SocketMethods _socketMethods = SocketMethods();
  final pageCtr = PageController(initialPage: 0);

  @override
  void initState() {
    _socketMethods.updateStartTimer(context);
    _socketMethods.pointIncreaseListener(context);
    _socketMethods.startGameTimer(Provider.of<RoomDataProvider>(context, listen: false).roomData['_id']);
    print('initstate');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final roomDataProvider = Provider.of<RoomDataProvider>(context);
    final clientStateProvider = Provider.of<ClientDataProvider>(context);
    final roomData = roomDataProvider.roomData;
    final count = clientStateProvider.clientState['timer']['countDown'];
    final questions = roomDataProvider.roomData['questions'];
    print('${count} + quiz_screen building');
    // print('width => ${MediaQuery.of(context).size.width}');
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
          body: PageView.builder(
              controller: pageCtr,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                if (pageCtr.position.haveDimensions) {
                  // print('${count} in haveDimensions');
                  if (count < 1 && pageCtr.page!.toInt() + 1 < questions.length) {
                    // print('${count}! -> timer finish!');
                      Timer(Duration(seconds: 3), () {
                        _socketMethods.startGameTimer(roomData['_id']);
                      });
                    Timer(Duration(seconds: 4), () {
                      // print("Yeah, this line is printed after 4 seconds");
                      pageCtr.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                }
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      color: Colors.black.withOpacity(0.2),
                      margin: const EdgeInsets.only(
                        top: 50.0,
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Q ${index + 1} / ${questions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          count != 0 ? Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.orange,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              // padding: const EdgeInsets.symmetric(
                              //   vertical: 10.0,
                              // ),
                              width: MediaQuery.of(context).size.width - 2.0,
                              height: 100.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                        question['oxQuestion'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true, // 텍스트가 영역을 넘어갈 경우 줄바꿈 여부
                                        textAlign: TextAlign.center, // 정렬
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ) : Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.orange,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              // padding: const EdgeInsets.symmetric(
                              //   vertical: 10.0,
                              // ),
                              width: MediaQuery.of(context).size.width - 2.0,
                              height: 100.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '정답: ${question['oxAnswer'].toUpperCase()}',
                                    style: const TextStyle(
                                      color: Colors.lightGreenAccent,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Flexible(
                                    child: Text(
                                      question['explanation'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true, // 텍스트가 영역을 넘어갈 경우 줄바꿈 여부
                                      textAlign: TextAlign.center, // 정렬
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Chip(
                          label: Text(
                            clientStateProvider.clientState['timer']['msg'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          clientStateProvider.clientState['timer']['countDown']
                              .toString(),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            print('O touch'),
                            _socketMethods.handleOSubmit(
                              'O',
                              roomData['_id'],
                            )
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'O',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 100,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 40,
                                        color: Colors.blue,
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            print('X touch'),
                            _socketMethods.handleOSubmit(
                              'X',
                              roomData['_id'],
                            )
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'X',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 100,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 40,
                                        color: Colors.red,
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     const Scoreboard(),
                    //   ],
                    // ),
                    // // const TicTacToeBoard(),
                    // Text('나 : ${roomData['turn']['nickname']}'),
                  ],
                );
              },
            )),
    )));
  }
}
