import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mp_game/provider/client_data_provider.dart';

class QuizQuestions extends StatelessWidget {
  final PageController pageController;

  // final QuizState state;
  final List<dynamic> questions;

  QuizQuestions({
    Key? key,
    required this.pageController,
    // required this.state,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final question = questions[index];
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
            Consumer(
              builder: (context, ref, child) {
                final clientStateProvider =
                    ref.watch(clientDataProvider).toJson();
                print(clientStateProvider['timer']['countDown']);
                if (clientStateProvider['timer']['countDown'] < 1 &&
                    pageController.page!.toInt() + 1 < questions.length) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                }
                return Column(
                  children: [
                    Chip(
                      label: Text(
                        clientStateProvider['timer']['msg'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      clientStateProvider['timer']['countDown'].toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
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
          ],
        );
      },
    );
  }
}
