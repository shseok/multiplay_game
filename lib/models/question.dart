/// id : 1
/// oxQuestion : "이 앱의 이름은 다모여이다."
/// oxAnswer : "o"
/// explanation : "이 앱의 이름은 다모여가 맞다."

class Question {
  Question({
      this.id, 
      this.oxQuestion, 
      this.oxAnswer, 
      this.explanation,});

  Question.fromJson(dynamic json) {
    id = json['id'];
    oxQuestion = json['oxQuestion'];
    oxAnswer = json['oxAnswer'];
    explanation = json['explanation'];
  }
  int? id;
  String? oxQuestion;
  String? oxAnswer;
  String? explanation;
Question copyWith({  int? id,
  String? oxQuestion,
  String? oxAnswer,
  String? explanation,
}) => Question(  id: id ?? this.id,
  oxQuestion: oxQuestion ?? this.oxQuestion,
  oxAnswer: oxAnswer ?? this.oxAnswer,
  explanation: explanation ?? this.explanation,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['oxQuestion'] = oxQuestion;
    map['oxAnswer'] = oxAnswer;
    map['explanation'] = explanation;
    return map;
  }

}