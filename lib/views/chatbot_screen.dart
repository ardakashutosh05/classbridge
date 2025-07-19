import 'dart:developer';

import 'package:classbridge/components/message_tile.dart';
import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/constants/text_const.dart';
import 'package:classbridge/model/chat_model.dart';
import 'package:classbridge/model/message_model.dart';
import 'package:classbridge/model/user_model.dart';
import 'package:classbridge/viewmodels/chatbot_viewmodel.dart';
import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId});
  final String chatId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late bool existingChat;
  late TextEditingController _messageController;
  FocusNode _messageFocusNode = FocusNode();
  String message = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<List<MessageModel>> getGroupChat(String productId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String chatId = HelperClass.generateRandomString();
    _messageController = TextEditingController();
    _messageFocusNode.addListener(() {
      if (!_messageFocusNode.hasFocus) {
        // Clear the input field after losing focus
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      // drawer: CustomDrawer(),
      // backgroundColor: kBackgroundColor,
      appBar: AppBar(
          title: const Row(
        children: [
          Icon(Icons.forum_rounded, size: 28),
          SizedBox(width: 10),
          Text(
            'Chat With AI (Google Gemini)',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
        ],
      )),
      body: Consumer<FetchData>(builder: (context, data, child) {
        return Column(children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: getGroupChat(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  existingChat = false;
                  log("existing chat is set to true.");
                  return Center(
                      child: Text(
                    'Easy Assessment',
                    style: kHeadingTextStyle.copyWith(color: kSoftWhite),
                  ));
                } else if (snapshot.hasData) {
                  existingChat = true;
                  log("existing chat is set to false.");
                  List<MessageModel> messages = snapshot.data!;

                  return ListView.builder(
                    reverse:
                        true, // To display the latest messages at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      MessageModel message = messages[index];
                      return MessageTile(
                          messageModel: message, user: data.user!);
                    },
                  );
                } else {
                  return Center(child: Text('No messages available.'));
                }
              },
            ),
          ),
          Container(
            height: height * 0.08,
            // color: kBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.85,
                  height: height * 0.065,
                  // padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                        BorderRadius.circular(height * 0.04), // Stadium shape
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: () {
                          // show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Voice chat coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        color: kSoftWhite,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0, right: 8),
                          child: TextFormField(
                            style: TextStyle(
                                color: kSoftWhite), // Customize text style
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Message',
                              hintStyle: TextStyle(color: kSoftWhite),
                              border: InputBorder.none,
                            ),

                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            // onChanged: (value) {
                            //   setState(() {
                            //     message = value;
                            //   });
                            // },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 8.0), // Add spacing between input and send button
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        MessageModel messageModel = MessageModel(
                            prompt: _messageController.text,
                            answer: "wait",
                            timestamp: DateTime.now().millisecondsSinceEpoch,
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            messageStatus: "wait",
                            chatRef: widget.chatId,
                            modelName: "start");

                        if (existingChat) {
                          ChattingViewModel().pushNewMessage(
                              widget.chatId, context, messageModel);
                          _messageController.clear();
                        } else {
                          ChatModel chatModel = ChatModel(
                              chatRef: widget.chatId,
                              title: "",
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              timestamp: DateTime.now().millisecondsSinceEpoch);
                          ChattingViewModel()
                              .pushNewChat(chatModel, context, messageModel);
                          _messageController.clear();
                        }
                      }
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
