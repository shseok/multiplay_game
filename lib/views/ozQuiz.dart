import 'package:flutter/material.dart';
import 'package:mp_game/views/scoreboard.dart';
import 'package:provider/provider.dart';
import '../provider/client_data_provider.dart';
import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';

class OxQuiz extends StatefulWidget {
  final Map<String, dynamic> roomData;

  const OxQuiz({Key? key, required this.roomData}) : super(key: key);

  @override
  State<OxQuiz> createState() => _OxQuizState();
}

class _OxQuizState extends State<OxQuiz> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    _socketMethods.updateStartTimer(context);
    _socketMethods.startGameTimer(widget.roomData['_id']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context, widget.roomData, _socketMethods);
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> roomData,
      SocketMethods socketMethods) {
    return QuizQuestions(
      roomData: roomData,
      socketMethods: socketMethods,
    );
  }
}

class QuizQuestions extends StatelessWidget {
  // parents -> stateful
  final Map<String, dynamic> roomData;
  final SocketMethods socketMethods;
  final pageCtr = PageController(initialPage: 0);

  QuizQuestions({Key? key, required this.roomData, required this.socketMethods})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = roomData['questions'];
    final clientStateProvider = Provider.of<ClientDataProvider>(context);
    print('${clientStateProvider.clientState['timer']['countDown']}');
    return PageView.builder(
      controller: pageCtr,
      physics: NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        if(pageCtr.position.haveDimensions) {
          if (clientStateProvider.clientState['timer']['countDown'] < 1 &&
              index + 1 < questions.length) { // pageCtr.page!.toInt() + 1 => index + 1
            print('${clientStateProvider.clientState['timer']['countDown']}! -> timer finish!');
            socketMethods.startGameTimer(roomData['_id']);
            pageCtr.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        }
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              color: Colors.black.withOpacity(0.2),
              margin: const EdgeInsets.only(
                top: 80.0,
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
                  SizedBox(height: 30.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.orange,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              question['oxQuestion'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                  onTap: () => {print('O touch')},
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
                  onTap: () => {print('X touch')},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Scoreboard(),
              ],
            ),
            // const TicTacToeBoard(),
            Text(
                '나 : ${roomData['turn']['nickname']}'),
          ],
        );
      },
    );
  }
}
