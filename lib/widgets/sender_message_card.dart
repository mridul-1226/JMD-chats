import 'package:chatting_app/data/colors.dart';
import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message, time;

  const SenderMessageCard({super.key, required this.message, required this.time});

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
                padding: const EdgeInsets.only(
                    left: 10, right: 30, top: 5, bottom: 20),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
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
