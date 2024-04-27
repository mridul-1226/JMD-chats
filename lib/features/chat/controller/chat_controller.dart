import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/chat/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider), ref: ref));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(
      BuildContext context, String text, String receiverUserId) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            senderUserData: value!,
            receiverUserId: receiverUserId));
  }
}
