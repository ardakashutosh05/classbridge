import 'package:classbridge/model/parent_teacher_message_model.dart';
import 'package:classbridge/viewmodels/chat_service.dart';
import 'package:flutter/material.dart';


class ParentsTeacherChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserName;

  const ParentsTeacherChatScreen({
    Key? key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  State<ParentsTeacherChatScreen> createState() => _ParentsTeacherChatScreenState();
}

class _ParentsTeacherChatScreenState extends State<ParentsTeacherChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 24, // Reduce the width of the leading (back button) area

        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600],),
            ),
            SizedBox(width: 10),
            Text(widget.otherUserName, style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 20),),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ParentTeacherMessage>>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message.content),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _chatService.sendMessage(
                        widget.chatId,
                        widget.currentUserId,
                        _messageController.text.trim(),
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}