class StudentModel {
  final String name;
  final String id;
  final String className;

  StudentModel({
    required this.name,
    required this.id,
    required this.className,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      id: json['id'],
      className: json['class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'class': className,
    };
  }
}
