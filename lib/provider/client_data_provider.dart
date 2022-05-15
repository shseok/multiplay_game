import 'package:flutter/material.dart';
import '../models/client.dart';

class ClientDataProvider extends ChangeNotifier {
  // Map<String, dynamic> _clientData = {};
  //
  // Map<String, dynamic> get clientData => _clientData;
  //
  // setClientData(Map<String, dynamic> data){ // updateClientData (timer)
  //   _clientData = data;
  //   notifyListeners();
  // }
  ClientState _clientState = ClientState(
    timer: {
      'countDown': '',
      'msg': '',
    },
  );
  Map<String, dynamic> get clientState => _clientState.toJson();

  setClientState(timer) {
    _clientState = ClientState(timer: timer);
    notifyListeners();
  }

}