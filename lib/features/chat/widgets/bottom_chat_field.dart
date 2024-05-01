import 'dart:io';
import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/common/providers/message_reply_provider.dart';
import 'package:chatting_app/common/utils/utils.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:chatting_app/features/chat/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isRecording = false;
  bool isRecorderInit = false;
  FlutterSoundRecorder? _soundRecorder;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _message.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _message.text.trim(),
            widget.receiverUserId,
          );

      _message.text = '';
      setState(() {
        isShowSendButton = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/audio_record.aac';
      if(!isRecorderInit){
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
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

  void selectGif() async {
    GiphyGif? gif = await pickGif(context);
    if(gif != null){
      ref.read(chatControllerProvider).sendGIFMessage(context, gif.url, widget.receiverUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? MessageReplyPreview(widget.receiverUserId) : const SizedBox(),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
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
                          onPressed: selectGif,
                          icon: Icon(Icons.gif_box_outlined),
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
                  isShowSendButton
                      ? Icons.send_rounded
                      : isRecording
                          ? Icons.close
                          : Icons.mic,
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
