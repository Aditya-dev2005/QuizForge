import 'questions.dart';

class QuizBrain {
  int _questionNumber = 0; // private tracker for current question

  final List<Questions> _questionBank = [
    Questions(
      q: 'In Test cricket, the longest individual innings in terms of time lasted over 16 hours.',
      a: true,
    ),
    Questions(
      q: 'A bowler can be credited with a wicket on a wide delivery.',
      a: true,
    ),
    Questions(
      q: 'The first-ever day/night Test match was played in 2016 between Australia and New Zealand.',
      a: false,
    ),
    Questions(
      q: 'A batsman can be out for “timed out” if they take more than 5 minutes to take strike.',
      a: true,
    ),
    Questions(
      q: 'Sir Donald Bradman’s batting average was above 100 in Test cricket.',
      a: false,
    ),
    Questions(
      q: 'The term “Mankading” comes from a dismissal executed by Vinoo Mankad.',
      a: true,
    ),
    Questions(
      q: 'In cricket, the maximum number of players allowed outside the 30-yard circle in the first 10 overs of an ODI is 3.',
      a: false,
    ),
    Questions(
      q: 'The heaviest cricket bat ever used in a professional match weighed more than 3 kilograms.',
      a: true,
    ),
    Questions(
      q: 'Only one bowler in history has taken all 10 wickets in a single ODI innings.',
      a: false,
    ),
    Questions(
      q: 'The highest successful run chase in Test cricket is over 400 runs.',
      a: true,
    ),
    Questions(
      q: 'A substitute fielder is allowed to keep wicket in a Test match.',
      a: false,
    ),
    Questions(
      q: 'The 2019 Cricket World Cup final was decided by a boundary count rule.',
      a: true,
    ),
    Questions(
      q: 'It is possible to score 8 runs off a single ball without overthrows.',
      a: false,
    ),
    Questions(
      q: 'The “Bodyline” tactic was famously used by Australia against England in the 1930s.',
      a: false,
    ),
    Questions(
      q: 'A bowler can be no-balled for having their back foot land outside the return crease.',
      a: true,
    ),
  ];

  /// Returns the current question text
  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  /// Returns the correct answer for the current question
  bool getCorrectAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  /// Moves to the next question if not finished
  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  /// Returns true if quiz has reached the last question
  bool isFinished() {
    return _questionNumber >= _questionBank.length - 1;
  }

  /// Resets the quiz back to first question
  void reset() {
    _questionNumber = 0;
  }

  /// Returns total number of questions
  int totalQuestions() {
    return _questionBank.length;
  }

  /// Returns current question index + 1 (for display)
  int currentQuestionNumber() {
    return _questionNumber + 1;
  }
}
