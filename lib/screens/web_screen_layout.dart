import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:chatting_app/features/chat/screens/chat_screen.dart';
import 'package:chatting_app/features/chat/widgets/chat_list.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:chatting_app/widgets/web_input_message.dart';
import 'package:chatting_app/widgets/web_chat_appbar.dart';
import 'package:chatting_app/widgets/web_profile_bar.dart';
import 'package:chatting_app/widgets/web_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebScreenLayout extends ConsumerWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const WebProfileBar(),
                  const WebSearchBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: StreamBuilder<List<ChatContactModel>>(
                        stream: ref.watch(chatControllerProvider).getChatList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingScreen();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ChatScreen.routeName,
                                            arguments: {
                                              'name':
                                                  (snapshot.data![index].name),
                                              'uid': (snapshot
                                                  .data![index].contactId),
                                            });
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data![index].profilePic),
                                          radius: 25,
                                        ),
                                        title: Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        trailing: Icon(
                                          Icons.circle,
                                          color: snapshot.data![index].isOnline
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: dividerColor,
                                    indent: 85,
                                  )
                                ],
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgroundImage.png'),
                  fit: BoxFit.cover),
            ),
            child: const Column(
              children: [
                WebCharAppBar(),
                Expanded(child: ChatList('')),
                InputMessage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
