import 'package:chatting_app/data/info.dart';
import 'package:chatting_app/widgets/my_message_card.dart';
import 'package:chatting_app/widgets/sender_message_card.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (messages[index]['isMe'] == true) {
            return MyMessageCard(
                message: messages[index]['text'].toString(),
                time: messages[index]['time'].toString());
          } else {
            return SenderMessageCard(
                message: messages[index]['text'].toString(),
                time: messages[index]['time'].toString());
          }
        }
        );
  }
}
