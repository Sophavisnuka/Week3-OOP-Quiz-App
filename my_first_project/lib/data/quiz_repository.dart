import 'dart:convert';
import 'dart:io';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;

  QuizRepository(this.filePath);

  Quiz readQuiz() {
    final file = File(filePath); //open a file handle

    //Check if file exists before trying to read it
    if (!file.existsSync()) {
      throw Exception('File not found at path: $filePath');
    }

    // Read and decode the JSON content
    final content = file.readAsStringSync(); // read entire file as text
    final data = jsonDecode(content); // convert JSON text → Map<String, dynamic>

    // Map JSON to domain objects
    var questionsJson = data['questions'] as List; //extract the question from json file as a List 
    var questions = questionsJson.map((q) {
      return Question(
        title: q['title'],
        choices: List<String>.from(q['choices']),
        goodChoice: q['goodChoice'],
        point: q['point'] ?? 1, // use correct key & default
      );
    }).toList();

    return Quiz(questions: questions);
  }

  void saveSubmission({required String playerName, required List<Answer> answers, required int scorePercentage, required int totalPoint}) {
    final submissionFile = File('lib/data/submissions.json');

    //Create file if not exists
    if (!submissionFile.existsSync()) {
      submissionFile.writeAsStringSync(jsonEncode({'submissions': []}));
    }

    //Read file safely
    final content = submissionFile.readAsStringSync();

    Map<String, dynamic> data;
    if (content.trim().isEmpty) {
      // If file empty
      data = {'submissions': []};
    } else {
      data = jsonDecode(content);
    }

    //Make sure there's always a list
    List submissionsList = data['submissions'] ?? [];

    // Convert answers to map form
    final answerList = answers.map((a) => {
      'questionId': a.questionId,
      'answerChoice': a.answerChoice,
    }).toList();

    // New entry
    final newEntry = {
      'playerName': playerName,
      'scorePercentage': scorePercentage,
      'totalPoint': totalPoint,
      'answers': answerList,
      'timestamp': DateTime.now().toIso8601String(),
    };

    submissionsList.add(newEntry);
    data['submissions'] = submissionsList;

    //Write back to JSON
    const encoder = JsonEncoder.withIndent('  ');
    submissionFile.writeAsStringSync(encoder.convert(data), flush: true);
    
    print('Saved submission for $playerName to submissions.json');
  }
}
