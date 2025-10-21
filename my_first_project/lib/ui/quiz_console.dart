import 'dart:io';
import '../domain/quiz.dart';
import '../data/quiz_repository.dart';

class QuizConsole {
  Quiz quiz;
  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');
    final repo = QuizRepository('lib/data/quiz_data.json');
    while (true) {
      stdout.write('Your name: ');
      String? nameInput = stdin.readLineSync();

      // Exit if name is empty
      if (nameInput == null || nameInput.isEmpty) {
        print('\n--- Quiz Ended ---');
        quiz.displayAllScores();
        break;
      }

      for (var question in quiz.questions) {
        print('\nQuestion ID: ${question.id}');
        print('Question: ${question.title} - (${question.point} point)');
        print('Choices: ${question.choices}');
        stdout.write('Your answer: ');
        String? userInput = stdin.readLineSync();

        if (userInput != null && userInput.isNotEmpty) {
          // changed: store questionId instead of Question object
          Answer answer = Answer(
            questionId: question.id,
            answerChoice: userInput,
          );
          quiz.addAnswer(answer);
        } else {
          print('No answer entered. Skipping question.');
        }
      }

      // pass the quiz instance to isGood()
      int score = quiz.getScoreInPercentage();
      int point = quiz.getPoint();

      // Add player
      Player player = Player(
        name: nameInput,
        score: point,
        scorePercentage: score,
      );
      quiz.addPlayer(player);

      print('\n--- Quiz Finished ---');
      print('$nameInput, your score: $score% correct');
      print('$nameInput, your point is: $point\n');

      repo.saveSubmission(
        playerName: nameInput,
        answers: quiz.answers,
        scorePercentage: score,
        totalPoint: point,
      );

      quiz.answers.clear(); // Clear answers for next player
    }
  }
}
