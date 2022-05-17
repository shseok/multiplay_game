import 'package:flutter/material.dart';
import 'package:mp_game/provider/client_data_provider.dart';
import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/game_ready_button.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateReadyTimer(context);
    roomIdController = TextEditingController(
      text:
      Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'],
    );
  }

  @override
  void dispose() {
    super.dispose();
    roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientStateProvider = Provider.of<ClientDataProvider>(context);
    return SafeArea(child:
    Container(
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                    clientStateProvider.clientState['timer']['countDown'].toString(),
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
          ),
        )
    ));
  }
}