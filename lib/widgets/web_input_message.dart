import 'package:chatting_app/data/colors.dart';
import 'package:flutter/material.dart';

class InputMessage extends StatelessWidget {
  const InputMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: dividerColor),
                      ),
                      color: chatBarMessage),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),),
                          IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
  }
}