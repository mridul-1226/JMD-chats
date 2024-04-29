import 'dart:io';

import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/common/utils/utils.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    required this.receiverUserId,
    super.key,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _message = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isShowEmojiContainer = false;

  @override
  void dispose() {
    super.dispose();
    _message.dispose();
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(context, _message.text, widget.receiverUserId);
    }
    _message.text = '';
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void showEmojiContainer() {
    setState(() {
      hideKeyboard();
      isShowEmojiContainer = true;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
      showKeyboard();
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
    } else {
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: _message,
                onTap: () {
                  setState(() {
                    isShowEmojiContainer = false;
                  });
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiContainer,
                          icon: const Icon(Icons.emoji_emotions_rounded),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.gif_box_outlined),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.camera_alt),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(Icons.attach_file),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Jai Mata Di...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            GestureDetector(
              onTap: sendTextMessage,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: Icon(
                  isShowSendButton ? Icons.send_rounded : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _message.text = _message.text + emoji.emoji;
                    if (!isShowSendButton) {
                      isShowSendButton = true;
                    }
                    setState(() {});
                  },
                  onBackspacePressed: () {
                    _message.text =
                        _message.text.substring(0, _message.text.length - 1);
                    if (_message.text.isEmpty) {
                      isShowSendButton = false;
                    }
                    setState(() {});
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
