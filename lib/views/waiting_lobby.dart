import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_game/provider/client_data_provider.dart';
// import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/game_ready_button.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;

  @override
  void initState() {
    super.initState();
    // roomIdController = TextEditingController(
    //   text:
    //   Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'],
    // );
    // _socketMethods.updateTimer(context);
  }

  @override
  void dispose() {
    super.dispose();
    roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final roomStateProvider = ref.watch(roomDataProvider);
        roomIdController = TextEditingController(text: roomStateProvider['_id']);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Waiting for a player to join...'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: roomIdController,
              hintText: '',
              isReadOnly: true,
            ),
            const SizedBox(height: 20),
            GameReadyButton()
          ],
        );
      },
    );
  }
}