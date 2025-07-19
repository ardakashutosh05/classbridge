class ChatModel {
  final String chatRef;
  final String title;
  final int timestamp;
  final String uid;

  ChatModel({
    required this.chatRef,
    required this.title,
    required this.timestamp,
    required this.uid,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatRef: json['chatRef'],
      title: json['title'],
      timestamp: json['timestamp'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatRef': chatRef,
        'title': title,
        'timestamp': timestamp,
        'uid': uid,
      };
}
