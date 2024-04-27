import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:chatting_app/models/user_model.dart';
import 'package:chatting_app/features/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  static const String routeName = '/chat-screen';

  final String name;
  final String uid;
  const ChatScreen({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) return const LoadingScreen();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(snapshot.data!.isOnline ? 'Online' : 'Offline', style: const TextStyle(fontSize: 16),),
              ],
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call_outlined,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: ChatList()),
          const SizedBox(height: 5,),
          BottomChatField(receiverUserId: uid,),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }
}


