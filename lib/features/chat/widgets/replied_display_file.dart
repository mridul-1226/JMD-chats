import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/widgets/display_file.dart';
import 'package:flutter/material.dart';

class RepliedDisplayFile extends StatelessWidget {
  const RepliedDisplayFile(
      {super.key, required this.message, required this.type});
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? DisplayFile(
            message: message.length > 15
                ? '${message.substring(0, 15)}...'
                : message,
            type: type,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(bottom: 10),
                color: backgroundColor,
                child: Center(
                  child: DisplayFile(
                      message: type == MessageEnum.audio
                          ? '🎙️'
                          : type == MessageEnum.video
                              ? '🎥'
                              : message,
                      type: type == MessageEnum.audio ||
                           type == MessageEnum.video
                              ? MessageEnum.text
                              : type),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(type == MessageEnum.audio
                  ? 'Audio'
                  : type == MessageEnum.gif
                      ? 'GIF'
                      : type == MessageEnum.image
                          ? 'Image'
                          : type == MessageEnum.video
                              ? 'Video'
                              : 'Message'),
                              const SizedBox(width: 10,)
            ],
          );
  }
}
