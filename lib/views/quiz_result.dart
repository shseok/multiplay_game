import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mp_game/widgets/custom_button.dart';

class QuizResults extends ConsumerWidget {
  final Map<String, dynamic> questions;
  const QuizResults({
    Key? key,
    required this.questions
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          // '${state.correct.length} / ${questions.length}',
          '맞힌개수/${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40.0),
        CustomButton(
          text: 'New Quiz',
          onTap: () {
            // ref.refresh(
            //     quizRepositoryProvider); // watch 상태에서 바뀐걸 인지하니까 다시 데이터를 불러옴
            // ref.read(quizControllerProvider.notifier).reset();
          },
        ),
      ],
    );
  }
}
