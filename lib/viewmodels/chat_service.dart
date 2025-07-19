import 'package:classbridge/model/parent_teacher_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classbridge/model/user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all teachers
  Stream<List<UserModel>> getAllTeachers() {
    return _firestore
        .collection('users')
        .where("studentId", isEqualTo: "")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }
  

  // Get all parents
  Stream<List<UserModel>> getAllParents() {
    return _firestore
        .collection('users')
        .where("studentId", isNotEqualTo: "")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }

  // Check if chat room exists
  Future<String?> getChatRoomId(String parentId, String teacherId) async {
    final snapshot = await _firestore
        .collection('chat_rooms')
        .where('parentId', isEqualTo: parentId)
        .where('teacherId', isEqualTo: teacherId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  // Create a new chat room
  Future<String> createChatRoom(String parentId, String teacherId) async {
    // Check if chat room already exists
    final existingChatId = await getChatRoomId(parentId, teacherId);
    if (existingChatId != null) {
      return existingChatId;
    }

    final chatRoom = ChatRoom(
      chatId: '',
      parentId: parentId,
      teacherId: teacherId,
      lastMessageTime: DateTime.now().millisecondsSinceEpoch,
      lastMessage: 'Chat started',
    );

    final docRef = await _firestore.collection('chat_rooms').add(chatRoom.toJson());
    await docRef.update({'chatId': docRef.id});
    return docRef.id;
  }

  // Send a message
  Future<void> sendMessage(String chatId, String senderId, String content) async {
    final message = ParentTeacherMessage(
      messageId: '',
      senderId: senderId,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isRead: false,
    );

    final docRef = await _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());

    await docRef.update({'messageId': docRef.id});

    // Update last message in chat room
    await _firestore.collection('chat_rooms').doc(chatId).update({
      'lastMessage': content,
      'lastMessageTime': message.timestamp,
    });
  }

  // Get chat rooms for a user (either parent or teacher)
  Stream<List<ChatRoom>> getChatRooms(String userId, bool isTeacher) {
    final field = isTeacher ? 'teacherId' : 'parentId';
    return _firestore
        .collection('chat_rooms')
        .where(field, isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromJson(doc.data())).toList());
  }

  // Get messages for a specific chat room
  Stream<List<ParentTeacherMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParentTeacherMessage.fromJson(doc.data()))
            .toList());
  }
}