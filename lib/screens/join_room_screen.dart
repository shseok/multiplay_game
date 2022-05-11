import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {

  static String routeName = '/join-room';

  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _gameIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _gameIdController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Responsive(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                shadows: [
                  Shadow(
                    blurRadius: 40,
                    color: Colors.blue,
                  ),
                ],
                text: '방 참여하기',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),
              CustomTextField(controller: _nameController,
                hintText: '닉네임을 입력해주세요',),
              SizedBox(height: 20),
              CustomTextField(controller: _nameController,
                hintText: '게임 방 번호를 입력해주세요',),
              SizedBox(height: size.height * 0.03),
              CustomButton(onTap: (){}, text: '생성'),
            ],
          ),
        ),
      ),
    );
  }
}
