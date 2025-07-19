class MessageModel {
  final String chatRef;
  final String prompt;
  final String answer;
  final int timestamp;
  final String uid;
  final String modelName;
  final String messageStatus;

  MessageModel({
    required this.chatRef,
    required this.prompt,
    required this.answer,
    required this.timestamp,
    required this.uid,
    required this.modelName,
    required this.messageStatus,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chatRef: json['chatRef'],
      prompt: json['prompt'],
      answer: json['answer'],
      timestamp: json['timestamp'],
      uid: json['uid'],
      modelName: json['modelName'],
      messageStatus: json['messageStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatRef': chatRef,
        'prompt': prompt,
        'answer': answer,
        'timestamp': timestamp,
        'uid': uid,
        'modelName': modelName,
        'messageStatus': messageStatus,
      };
}
