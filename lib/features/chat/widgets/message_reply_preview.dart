import 'package:chatting_app/common/providers/message_reply_provider.dart';
import 'package:chatting_app/features/chat/widgets/display_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  final String receiverUserId;
  const MessageReplyPreview(this.receiverUserId, {super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',//(FirebaseFirestore.instance.collection('users').doc(receiverUserId).get().then((value) => value.data()!['name']) as String),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 25,
                ),
                onTap: () {
                  cancelReply(ref);
                },
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayFile(message: messageReply.message, type: messageReply.messageEnum),
        ],
      ),
    );
  }
}
