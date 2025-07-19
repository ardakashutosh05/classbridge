import 'dart:convert';
import 'dart:developer';

import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/model/chat_model.dart';
import 'package:classbridge/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ChattingViewModel {
  Future<String> pushNewChat(ChatModel chatModel, BuildContext context,
      MessageModel messageModel) async {
    try {
      String messageId = HelperClass.generateRandomString();
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatModel.chatRef)
          .set(chatModel.toJson());
      log("new chat created");

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatModel.chatRef)
          .collection("messages")
          .doc(messageId)
          .set(messageModel.toJson());
      log("message sent. waiting for response.");

      String response =
          await getResponse(chatModel.chatRef, messageModel, context);
      log("response received: $response");
      if (response == "exception" ||
          response == "failure" ||
          response == "error") {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatModel.chatRef)
            .collection("messages")
            .doc(messageId)
            .update({"answer": "error", "messageStatus": "error"});
        return "error";
      } else {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatModel.chatRef)
            .collection("messages")
            .doc(messageId)
            .update({"answer": response, "messageStatus": "answered"});
        return "success";
      }
    } catch (e) {
      log("Error creating new chat: $e");
      return "exception";
    }
  }

  Future<String> pushNewMessage(
      String chatId, BuildContext context, MessageModel messageModel) async {
    try {
      String messageId = HelperClass.generateRandomString();

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .set(messageModel.toJson());
      log("message sent. waiting for response.");

      String response = await getResponse(chatId, messageModel, context);
      log("response received: $response");
      if (response == "exception" ||
          response == "failure" ||
          response == "error") {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .doc(messageId)
            .update({"answer": "error", "messageStatus": "error"});
        return "error";
      } else {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .doc(messageId)
            .update({"answer": response, "messageStatus": "answered"});
        return "success";
      }
    } catch (e) {
      log("Error creating new chat: $e");
      return "exception";
    }
  }

  Future<String> getResponse(
      String chatId, MessageModel messageModel, BuildContext context) async {
    try {
      final payload = json.encode({
        "contents": [
          {
            "parts": [
              {"text": messageModel.prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 1.0,
          "maxOutputTokens": 600,
        }
      });

      final headers = {
        'Content-Type': 'application/json',
      };

      final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyDmQDpaD74beB0M3GNyaHKvvL9AZp_CQr0');

      final response = await http.post(
        uri,
        headers: headers,
        body: payload,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Safely parse the nested response
        if (responseData.containsKey('candidates') &&
            responseData['candidates'] is List &&
            responseData['candidates'].isNotEmpty) {
          final firstCandidate = responseData['candidates'][0];
          if (firstCandidate['content'] != null &&
              firstCandidate['content']['parts'] != null &&
              firstCandidate['content']['parts'].isNotEmpty) {
            final text =
                firstCandidate['content']['parts'][0]['text'] as String?;
            return text ?? "No response text found";
          }
        }
        return "Invalid response format from API";
      } else {
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      log("Error getting response: $e");
      return "An error occurred while processing your request";
    }
  }
}
