import 'package:flutter/material.dart';
import 'package:mp_game/responsive/responsive.dart';
import 'package:mp_game/widgets/custom_textfield.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    print(size.height);

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
                text: '방 만들기',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),
              CustomTextField(controller: _nameController,
                hintText: '닉네임을 입력해주세요',),
              SizedBox(height: size.height * 0.03),
              CustomButton(onTap: (){}, text: '생성'),
            ],
          ),
        ),
      ),
    );
  }
}
