class SubjectModel {
  final String subjectName;
  int numberOfTests;
  List<int> scores = [];

  SubjectModel(
      {required this.subjectName,
      this.numberOfTests = 0,
      this.scores = const []});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectName: json['subjectName'],
      numberOfTests: json['numberOfTests'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'numberOfTests': numberOfTests,
    };
  }
}
