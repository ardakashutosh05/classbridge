import 'package:classbridge/model/parent_teacher_message_model.dart';
import 'package:classbridge/viewmodels/chat_service.dart';
import 'package:classbridge/views/parents_teacher_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classbridge/views/user_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classbridge/model/user_model.dart';


class ChatListScreen extends StatefulWidget {
  final String userId;
  bool isTeacher;

  ChatListScreen({
    Key? key,
    required this.userId,
    required this.isTeacher,
  }) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    checkParentChats();
  }

  Future<void> checkParentChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("type");
    if (type == "parents") {
      setState(() {
        widget.isTeacher = false;
      });
    } else {
      setState(() {
        widget.isTeacher = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Row(
          children: [
            Icon(Icons.forum_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'Feedbacks',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ],
        )),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getChatRooms(widget.userId, widget.isTeacher),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!;

          if (chatRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isTeacher
                        ? 'No parent chats yet'
                        : 'No teacher chats yet',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSelectionScreen(
                            currentUserId: widget.userId,
                            isTeacher: widget.isTeacher,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      widget.isTeacher ? 'Start Chat with Parent' : 'Start Chat with Teacher',
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600],),
                    ),
                    title: FutureBuilder<String>(
                      future: _getUserName(
                        widget.isTeacher ? chatRoom.parentId : chatRoom.teacherId,
                        widget.isTeacher,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!, style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 16),);
                        }
                        return Text(widget.isTeacher
                            ? 'Parent ${chatRoom.parentId}'
                            : 'Teacher ${chatRoom.teacherId}');
                      },
                    ),
                    subtitle: Text(chatRoom.lastMessage, style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w400, fontSize: 14),),
                    onTap: () async {
                      final parentName = await _getUserName(chatRoom.parentId, widget.isTeacher);
                      final teacherName = await _getUserName(chatRoom.teacherId, widget.isTeacher);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentsTeacherChatScreen(
                            chatId: chatRoom.chatId,
                            currentUserId: widget.userId,
                            otherUserName: widget.isTeacher
                                ? parentName
                                : teacherName,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSelectionScreen(
                          currentUserId: widget.userId,
                          isTeacher: widget.isTeacher,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String> _getUserName(String userId, bool isTeacher) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();
    
    if (doc.exists) {
      final user = UserModel.fromJson(doc.data()!);
      return '${user.firstName} ${user.lastName}';
    }
    return 'Unknown User';
  }
}