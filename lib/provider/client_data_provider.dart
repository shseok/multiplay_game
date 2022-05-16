import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/client.dart';

class ClientNotifier extends StateNotifier<ClientState>{
  ClientNotifier(): super(ClientState(
    timer: {
      'countDown': '',
      'msg': '',
    },
  ));

  setClientState(timer) {
    state = state.copyWith(timer: timer);
  }
}

final clientDataProvider = StateNotifierProvider<ClientNotifier, ClientState>((ref){ // ref.watch(clientDataProvider).toJson()
  return ClientNotifier();
});


// class ClientDataProvider extends ChangeNotifier {
//   // Map<String, dynamic> _clientData = {};
//   //
//   // Map<String, dynamic> get clientData => _clientData;
//   //
//   // setClientData(Map<String, dynamic> data){ // updateClientData (timer)
//   //   _clientData = data;
//   //   notifyListeners();
//   // }
//   ClientState _clientState = ClientState(
//     timer: {
//       'countDown': '',
//       'msg': '',
//     },
//   );
//   Map<String, dynamic> get clientState => _clientState.toJson();
//
//   setClientState(timer) {
//     _clientState = ClientState(timer: timer);
//     notifyListeners();
//   }
//
// }