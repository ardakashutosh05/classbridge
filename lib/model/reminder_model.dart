class ReminderModel {
  final String text;
  final int timeStamp;

  ReminderModel({
    required this.text,
    required this.timeStamp,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      text: json['text'],
      timeStamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timeStamp, 
    };
  }
}