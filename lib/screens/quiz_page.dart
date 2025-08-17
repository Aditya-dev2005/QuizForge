// lib/screens/quiz_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quiz_category.dart';

class QuizPage extends StatefulWidget {
  final QuizCategory category;
  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _loading = true;
  String? _error;
  int _current = 0;
  int _score = 0;

  // ✅ scoreKeeper row ke liye
  List<Icon> _scoreKeeper = [];

  // Each item: {question, correct, difficulty}
  List<Map<String, String>> _questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _loading = true;
      _error = null;
      _questions = [];
      _current = 0;
      _score = 0;
      _scoreKeeper.clear();
    });

    // Using base64 encoding to avoid HTML entity issues from OpenTDB
    final uri = Uri.parse(
      'https://opentdb.com/api.php?amount=15&category=${widget.category.id}&type=boolean&encode=base64',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode != 200) {
        setState(() {
          _error = 'Network error: ${res.statusCode}';
          _loading = false;
        });
        return;
      }

      final body = jsonDecode(res.body);
      if (body['response_code'] != 0 || body['results'] is! List) {
        setState(() {
          _error = 'No questions available for this category.';
          _loading = false;
        });
        return;
      }

      final results = (body['results'] as List)
          .map<Map<String, String>>(
            (e) => {
              'question': utf8.decode(base64Decode(e['question'] as String)),
              'correct': utf8.decode(
                base64Decode(e['correct_answer'] as String),
              ),
              'difficulty': utf8.decode(
                base64Decode(e['difficulty'] as String),
              ),
            },
          )
          .toList();

      setState(() {
        _questions = results;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Failed to fetch questions.';
        _loading = false;
      });
    }
  }

  void _answer(bool userAnswer) {
    final bool correct = _questions[_current]['correct'] == 'True';

    setState(() {
      if (userAnswer == correct) {
        _score++;
        _scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
      } else {
        _scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
      }
    });

    if (_current < _questions.length - 1) {
      setState(() => _current++);
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('Your score: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to category screen
            },
            child: const Text('Back to Categories'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _fetchQuestions(); // restart same category
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text('Quiz: ${widget.category.name}'),
          backgroundColor: Colors.black87,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text('Quiz: ${widget.category.name}'),
          backgroundColor: Colors.black87,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _fetchQuestions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_current];

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Quiz: ${widget.category.name}'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress & score
            Text(
              'Q ${_current + 1}/${_questions.length}   |   Score: $_score',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Difficulty
            Text(
              'Difficulty: ${q['difficulty']!.toUpperCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 24),
            // Question
            Expanded(
              child: Center(
                child: Text(
                  q['question']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // True / False buttons
            ElevatedButton(
              onPressed: () => _answer(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('True'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _answer(false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('False'),
            ),
            const SizedBox(height: 12),
            // ✅ ScoreKeeper row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _scoreKeeper),
            ),
          ],
        ),
      ),
    );
  }
}
