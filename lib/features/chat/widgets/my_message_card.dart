import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/widgets/display_file.dart';
import 'package:chatting_app/features/chat/widgets/replied_display_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message, time;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final String messageId;

  const MyMessageCard(
      {super.key,
      required this.message,
      required this.time,
      required this.type,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen,
      required this.messageId,
      required this.onRightSwipe});

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: (details) => onLeftSwipe(),
      onRightSwipe: (details) => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: 120,
          ),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          bottom: 25,
                          top: 5,
                          right: 5,
                          left: 5,
                        ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$username  ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 222, 147, 236),
                                    letterSpacing: 1.2),
                              ),
                              SizedBox(
                                  height: repliedMessageType == MessageEnum.text
                                      ? 0
                                      : 4),
                              RepliedDisplayFile(
                                message: repliedText,
                                type: repliedMessageType,
                              ),
                            ],
                          ),
                        ),
                      ],
                      DisplayFile(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        color: isSeen ? Colors.blue : Colors.white60,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
