class SubjectPerformance {
  final String subjectName;
  final List<TestScore> scores;
  final double averageScore;

  SubjectPerformance({
    required this.subjectName,
    required this.scores,
    required this.averageScore,
  });
}

class TestScore {
  final String testName;
  final double score;
  final DateTime date;

  TestScore({
    required this.testName,
    required this.score,
    required this.date,
  });
}