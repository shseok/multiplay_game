import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mp_game/provider/room_data_provider.dart';

import '../views/ox_quiz.dart';

class QuizScreen extends HookConsumerWidget {
  final Map<String, dynamic> roomStateProvider;
  const QuizScreen({
    Key? key,
    required this.roomStateProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     fit: BoxFit.cover,
      //     image: AssetImage('images/background.png'), // 배경 이미지
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildBody(context, pageController, roomStateProvider['questions']),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PageController pageController,
      List<dynamic> questions) {
    return Consumer(
      builder: (context, ref, child) {
        // 퀴즈 상태를 받고 해당 퀴즈의 상태가 완료되었으면 Results화면 그렇지 않으면 계속 진행
        return QuizQuestions(
          pageController: pageController,
          // state: quizState,
          questions: questions,
        );
        // QuizResult(questions: questions);
      },
    );
  }
}
