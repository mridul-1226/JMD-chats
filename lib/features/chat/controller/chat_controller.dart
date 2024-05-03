import 'dart:io';
import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/common/providers/message_reply_provider.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/chat/repositories/chat_repository.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider), ref: ref));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContactModel>> getChatList() {
    return chatRepository.getChatList();
  }

  Stream<List<MessageModel>> getMessages(String receiverId) {
    return chatRepository.getMessages(receiverId);
  }

  void sendTextMessage(
      BuildContext context, String text, String receiverUserId) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              senderUserData: value!,
              receiverUserId: receiverUserId,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(BuildContext context, File file, String receiverUserId,
      MessageEnum messageEnum) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              senderUserData: value!,
              receiverUserId: receiverUserId,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(
      BuildContext context, String gifUrl, String receiverUserId) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
      (value) {
        int gifPartIndex = gifUrl.lastIndexOf('-') + 1;
        String gifPart = gifUrl.substring(gifPartIndex);
        String newGifUrl = 'https://i.giphy.com/media/$gifPart/200.gif';
        return chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newGifUrl,
            senderUserData: value!,
            receiverUserId: receiverUserId,
            messageReply: messageReply);
      },
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }

  void deleteMessages(BuildContext context, String receiverId, String messageIds) {
    chatRepository.deleteMessages(context, receiverId, messageIds);
  }

  void editMessages(BuildContext context, String receiverId, String messageId, String text) {
    chatRepository.editMessage(context, receiverId, messageId, text);
  }

   void unsendMessages(BuildContext context, String receiverId, String messageIds) {
    chatRepository.unsendMessage(context, receiverId, messageIds);
  }
}
