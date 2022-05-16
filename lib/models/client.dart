// 추후 player와 합치기
class ClientState {
  final Map<String, dynamic> timer;

  ClientState({
    required this.timer,
  });

  Map<String, dynamic> toJson() => {
    'timer': timer,
  };

  ClientState copyWith({required Map<String, dynamic> timer}){
    return ClientState(timer: timer);
}
}