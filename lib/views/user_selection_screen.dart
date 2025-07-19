import 'package:classbridge/viewmodels/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:classbridge/model/user_model.dart';
import 'package:classbridge/views/parents_teacher_chat_screen.dart';


class UserSelectionScreen extends StatelessWidget {
  final String currentUserId;
  final bool isTeacher;
  final ChatService _chatService = ChatService();

  UserSelectionScreen({
    Key? key,
    required this.currentUserId,
    required this.isTeacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isTeacher ? 'Select Parent' : 'Select Teacher',   style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: isTeacher
            ? _chatService.getAllParents()
            : _chatService.getAllTeachers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          if (users.isEmpty) {
            return Center(
              child: Text(
                isTeacher ? 'No parents found' : 'No teachers found',
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(user.firstName[0], style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 16),),
                ),
                title: Text('${user.firstName} ${user.lastName}', style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 16),),
                subtitle: Text(user.email, style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w400, fontSize: 14),),
                onTap: () async {
                  final chatId = await _chatService.createChatRoom(
                    isTeacher ? user.id : currentUserId,
                    isTeacher ? currentUserId : user.id,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentsTeacherChatScreen(
                        chatId: chatId,
                        currentUserId: currentUserId,
                        otherUserName: '${user.firstName} ${user.lastName}',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
