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

  void saveSubmission(Submission submission) {
    final submissionFile = File('lib/data/submissions.json');

    // Create file if not exists
    if (!submissionFile.existsSync()) {
      throw new Exception('Submission.json file not found');
    }

    String content = submissionFile.readAsStringSync();
    Map<String, dynamic> data;
    if (content.trim().isEmpty) {
      data = {"submissions": []};
    } else {
      data = jsonDecode(content);
    }
   // Get the existing submissions (if any)
    List submissionsList = data['submissions'] ?? [];

    //Use the model's toJson() method
    submissionsList.add(submission.toJson());
    data['submissions'] = submissionsList;

    // Write back with pretty print
    const encoder = JsonEncoder.withIndent('  ');
    submissionFile.writeAsStringSync(encoder.convert(data), flush: true);

    print('Saved submission for ${submission.playerName}');
  }
}
