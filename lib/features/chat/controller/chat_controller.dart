import 'dart:io';

import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/chat/repositories/chat_repository.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:chatting_app/models/user_model.dart';
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
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            senderUserData: value!,
            receiverUserId: receiverUserId));
  }

  void sendFileMessage(BuildContext context, File file, String receiverUserId,
      MessageEnum messageEnum) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            senderUserData: value!,
            receiverUserId: receiverUserId,
            ref: ref,
            messageEnum: messageEnum));
  }
}
