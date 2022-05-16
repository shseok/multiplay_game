import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_game/provider/client_data_provider.dart';
// import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/game_ready_button.dart';

class WaitingLobby extends StatefulWidget {
  final Map<String, dynamic> roomStateProvider;
  const WaitingLobby({Key? key, required this.roomStateProvider}) : super(key: key);

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
        ref.watch(socketMethodsProvider.notifier).updateTimer(context);
        final clientStateProvider = ref.watch(clientDataProvider).toJson();
        roomIdController = TextEditingController(text: widget.roomStateProvider['_id']);
        print('client data in game screen => $clientStateProvider');

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
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
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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