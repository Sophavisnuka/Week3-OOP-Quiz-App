import 'package:test/test.dart';
import 'package:my_first_project/domain/quiz.dart';
// import 'package:my_first_project/data/quizRepository.dart';

void main() {
  test('My first test', () {
    Question q1 =
        Question(title: "4-2", choices: ["1", "2", "3"], goodChoice: "2");
    Question q2 =
        Question(title: "4+2", choices: ["1", "2", "6"], goodChoice: "6");

    Quiz quiz = Quiz(questions: [q1, q2]);

    // Answers reference questionId, not object
    quiz.addAnswer(Answer(questionId: q1.id, answerChoice: "2"));
    quiz.addAnswer(Answer(questionId: q2.id, answerChoice: "6"));

    expect(quiz.getScoreInPercentage(), equals(100));
  });
}
