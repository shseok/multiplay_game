import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    for (var player in roomDataProvider.roomData['players']) {
      print('each player info => ${player}');
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.red,
        ),
      ),
      padding: EdgeInsets.only(bottom: 50.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.military_tech, size: 30.0,color: Color(0xffA876DE)),
            ],
          ),
          for (var player in roomDataProvider.roomData['players'])
            Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
                      Text(
                        '1등',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.grey[300]!,
                            shadows: [
                              Shadow(
                                blurRadius: 30.0,
                                color: Colors.blue,
                                offset: Offset(2.0, 2.0),
                              ),
                            ]
                        ),
                      ),
                      Text(
                        '1등',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                            shadows: [
                              Shadow(
                                blurRadius: 30.0,
                                color: Colors.blue,
                                offset: Offset(2.0, 2.0),
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        player['nickname'],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.grey[300]!,
                          shadows: [
                            Shadow(
                              blurRadius: 30.0,
                              color: Colors.blue,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        player['nickname'],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                          shadows: [
                            Shadow(
                              blurRadius: 30.0,
                              color: Colors.blue,
                              offset: Offset(2.0, 2.0),
                            ),
                          ]
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
