import 'package:classbridge/constants/text_const.dart';
import 'package:classbridge/model/message_model.dart';
import 'package:classbridge/model/user_model.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  const MessageTile(
      {super.key, required this.messageModel, required this.user});
  final MessageModel messageModel;
  final UserModel user;
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text("YOU",
              style: kTextFieldTextStyle.copyWith(
                  color: Colors.black87, fontSize: 16, fontFamily: 'Gilroy')),
          subtitle: Text(
            widget.messageModel.prompt,
            style: kTextFieldTextStyle.copyWith(
                color: Colors.black87, fontFamily: 'Gilroy'),
          ),
        ),
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text("AI",
                style: kTextFieldTextStyle.copyWith(
                    color: Colors.black87, fontSize: 16, fontFamily: 'Gilroy')),
            subtitle: widget.messageModel.answer != "wait"
                ? buildFormattedMessage(widget.messageModel.answer)
                : Row(
                    children: [
                      Text("fetching your response..",
                          style: kTextFieldTextStyle.copyWith(
                              color: Colors.black87, fontFamily: 'Gilroy')),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.black87,
                          strokeWidth: 2.0,
                        ),
                      )
                    ],
                  ))
      ],
    );
  }
}

Widget buildFormattedMessage(String text) {
  final lines = text.split('\n');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: lines.map((line) {
      if (line.trim().startsWith('* ')) {
        // This is a bullet point
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ',
                  style:
                      TextStyle(color: Colors.black87, fontFamily: 'Gilroy')),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: parseFormattedText(line.substring(2)),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return RichText(
          text: TextSpan(
            children: parseFormattedText(line),
          ),
        );
      }
    }).toList(),
  );
}

// Update the parseFormattedText function to handle line breaks
List<TextSpan> parseFormattedText(String text) {
  if (text.isEmpty) return [const TextSpan(text: '')];

  final lines = text.split('\n');
  final List<TextSpan> spans = [];

  for (final line in lines) {
    final lineSpans = _parseBoldText(line);
    spans.addAll(lineSpans);
    spans.add(const TextSpan(text: '\n'));
  }

  return spans;
}

List<TextSpan> _parseBoldText(String text) {
  return text.split('*').asMap().entries.map((entry) {
    final isBold = entry.key.isOdd;
    final text = entry.value;

    return TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.black87,
        fontFamily: 'Gilroy',
      ),
    );
  }).toList();
}
