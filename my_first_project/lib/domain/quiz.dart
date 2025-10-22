import 'package:uuid/uuid.dart';

final uuid = Uuid();
class Question {
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({
    String? id,
    required this.title,
    required this.choices,
    required this.goodChoice,
    this.point = 1,
  }) : id = uuid.v4(); //generates unique id
}

class Answer {
  final String id;
  final String questionId;
  final String answerChoice;

  Answer({  
    String? id,
    required this.questionId,
    required this.answerChoice
  }) : id = id ?? uuid.v4();

  bool isGood(Quiz quiz) {
    final question = quiz.getQuestionById(questionId);
    return question != null && answerChoice == question.goodChoice;
  }
}

class Quiz {
  List<Question> questions;
  List<Answer> answers = [];
  Map<String, Player> players = {};

  Quiz({required this.questions});

  //getter method
  Question? getQuestionById(String id) {
    try {
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
  Answer? getAnswerById(String id) {
    try {
      return answers.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  void addAnswer(Answer answer) {
    this.answers.add(answer);
  }
  
  void addPlayer(Player player) {
    this.players[player.name] = player;
  }

  double getScoreInPercentage(){
    int totalScore = 0;
    for(Answer answer in answers){
      final question = getQuestionById(answer.questionId);
      if (question != null && answer.answerChoice == question.goodChoice) {
        totalScore++;
      }
    }
    return ((totalScore / questions.length)*100);
  }
  int getPoint() {
    int totalPoint = 0;
    for (var answer in answers) {
      final question = getQuestionById(answer.questionId);
      if (question != null && answer.answerChoice == question.goodChoice) {
        totalPoint += question.point;
      }
    }
    return totalPoint;
  }
  // Get all players' latest scores
  void displayAllScores() {
    if (players.isEmpty) {
      print('No players participated.');
      return;
    }
    
    print('\n=== Final Scores (Latest Attempts) ===');
    players.forEach((name, player) {
      print('$name: ${player.scorePercentage}% (${player.score} points)');
    });
  }
}
class Player {
  final String name;
  int score;
  double scorePercentage;
  Player({required this.name, this.score = 0, this.scorePercentage = 0});
}

class Submission {
  final String playerName;
  final double scorePercentage;
  final int totalPoint;
  final List<Answer> answers;

  Submission({
    required this.playerName,
    required this.scorePercentage,
    required this.totalPoint,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'scorePercentage': scorePercentage,
      'totalPoint': totalPoint,
      'answers': answers.map((a) => {
        'questionId': a.questionId,
        'answerChoice': a.answerChoice,
      }).toList(),
    };
  }
} 