class TestsModel {
  final String name;
  final Map<String, dynamic> data;

  TestsModel({required this.name, required this.data});
  factory TestsModel.fromJson(Map<String, dynamic> json) {
    return TestsModel(
      name: json['name'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}
