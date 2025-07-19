class ParentTeacherMessage {
  final String messageId;
  final String senderId;
  final String content;
  final int timestamp;
  final bool isRead;

  ParentTeacherMessage({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  factory ParentTeacherMessage.fromJson(Map<String, dynamic> json) {
    return ParentTeacherMessage(
      messageId: json['messageId'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: json['timestamp'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'senderId': senderId,
        'content': content,
        'timestamp': timestamp,
        'isRead': isRead,
      };
}

class ChatRoom {
  final String chatId;
  final String parentId;
  final String teacherId;
  final int lastMessageTime;
  final String lastMessage;

  ChatRoom({
    required this.chatId,
    required this.parentId,
    required this.teacherId,
    required this.lastMessageTime,
    required this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatId: json['chatId'],
      parentId: json['parentId'],
      teacherId: json['teacherId'],
      lastMessageTime: json['lastMessageTime'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'parentId': parentId,
        'teacherId': teacherId,
        'lastMessageTime': lastMessageTime,
        'lastMessage': lastMessage,
      };
}