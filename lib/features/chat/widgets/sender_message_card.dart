import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/widgets/display_file.dart';
import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message, time;
  final MessageEnum type;

  const SenderMessageCard({super.key, required this.message, required this.time, required this.type});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
               Padding(
                padding: type == MessageEnum.text
                    ? const EdgeInsets.only(
                        left: 10, right: 30, top: 5, bottom: 20)
                    : const EdgeInsets.only(
                        bottom: 25, top: 5, right: 5, left: 5),
                child: DisplayFile(message: message, type: type),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
