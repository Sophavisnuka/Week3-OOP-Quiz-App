import 'dart:io';
import 'dart:math';

import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;
  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');
    while (true) {
      stdout.write('Your name:  ');  
      String? nameInput = stdin.readLineSync();
      // Exit if name is empty
      if (nameInput == null || nameInput.isEmpty) {
        print('\n--- Quiz Ended ---');
        quiz.displayAllScores();
        break;
      }

      for (var question in quiz.questions) {
        print('Question: ${question.title} - (${question.point} point)');
        print('Choices: ${question.choices}');
        stdout.write('Your answer: ');  
        String? userInput = stdin.readLineSync();
        // Check for null input
        if (userInput != null && userInput.isNotEmpty) {
          Answer answer = Answer(question: question, answerChoice: userInput);
          quiz.addAnswer(answer);
        } else {
          print('No answer entered. Skipping question.');
        }
      }
      int score = quiz.getScoreInPercentage();
      int point = quiz.getPoint();
      
      //add player
      Player player = Player(name: nameInput, score: point, scorePercentage: score);
      quiz.addPlayer(player);

      print('--- Quiz Finished ---');
      print('$nameInput, Your score: $score % correct');
      print('$nameInput, Your point is: $point\n');

      quiz.answers.clear(); // Clear answers for the next player
    }
  } 
}
