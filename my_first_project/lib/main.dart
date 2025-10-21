import 'data/quiz_repository.dart';
import 'ui/quiz_console.dart';

void main() {
  final repo = QuizRepository('lib/data/quiz_data.json');
  final quiz = repo.readQuiz();

  final console = QuizConsole(quiz: quiz);
  console.startQuiz();
}
