import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/common/providers/message_reply_provider.dart';
import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:chatting_app/features/chat/widgets/my_message_card.dart';
import 'package:chatting_app/features/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList(this.receiverId, {super.key});

  final String receiverId;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  ScrollController messageScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref.read(chatControllerProvider).getMessages(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageScrollController.jumpTo(
              messageScrollController.position.maxScrollExtent,
            );
          });

          return ListView.builder(
              controller: messageScrollController,
              itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
              itemBuilder: (context, index) {
                var message = snapshot.data![index];
                var time = DateFormat.Hm().format(message.timeSent);

                if (!message.isSeen &&
                    message.receiverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setMessageSeen(
                      context, widget.receiverId, message.messageId);
                }

                if (message.senderId != widget.receiverId) {
                  return MyMessageCard(
                    message: message.text,
                    time: time,
                    type: message.type,
                    onLeftSwipe: () =>
                        onMessageSwipe(message.text, true, message.type),
                    repliedText: message.repliedMessage,
                    username: message.repliedTo,
                    repliedMessageType: message.repliedMessageType,
                    isSeen: message.isSeen,
                  );
                } else {
                  return SenderMessageCard(
                    message: message.text,
                    time: time,
                    type: message.type,
                    onRightSwipe: () =>
                        onMessageSwipe(message.text, false, message.type),
                    repliedText: message.repliedMessage,
                    username: message.repliedTo,
                    repliedMessageType: message.repliedMessageType,
                  );
                }
              });
        });
  }
}
