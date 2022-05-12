import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../account/account.dart';

class SocketClient{ // single tone pattern
  IO.Socket? socket;
  static SocketClient? _instance;
  
  SocketClient._internal(){ // initializeSocket
    socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance{
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}