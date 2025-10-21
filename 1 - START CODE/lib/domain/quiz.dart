import 'dart:math';

class Question{
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({
    required this.title,
    required this.choices,
    required this.goodChoice,
    this.point = 1,
  });

  int get getPoint => point;
}

class Answer{
  final Question question;
  final String answerChoice;
  
  Answer({required this.question, required this.answerChoice});

  bool isGood(){
    return this.answerChoice == question.goodChoice;
  }
}

class Quiz{
  List<Question> questions;
  List<Answer> answers =[];
  Map<String, Player> players = {};

  Quiz({required this.questions});

  void addAnswer(Answer answer) {
    this.answers.add(answer);
  }
  
  void addPlayer(Player player) {
    this.players[player.name] = player;
  }

  int getScoreInPercentage(){
    int totalSCore =0;
    for(Answer answer in answers){
      if (answer.isGood()) {
        totalSCore++;
      }
    }
    return ((totalSCore/ questions.length)*100).toInt();
  }
  int getPoint () {
    int totalPoint = 0;
    for (Answer answer in answers) {
      if (answer.isGood()) {
        totalPoint += answer.question.point;
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
  int scorePercentage;

  Player({required this.name, this.score = 0, this.scorePercentage = 0});
}