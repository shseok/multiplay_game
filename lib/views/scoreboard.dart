import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return Consumer(
      builder: (context, ref, child) {
        final roomStateProvider = ref.watch(roomDataProvider);
        return Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('현재 순위'),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('이름'), SizedBox(width: 30.0,), Text('점수')],
            ),
            for(var player in roomStateProvider['players']) Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    player['nickname'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 30.0,),
                  Text(
                    player['points'].toInt().toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
