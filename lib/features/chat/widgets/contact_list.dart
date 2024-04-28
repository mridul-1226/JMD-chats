import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:chatting_app/features/chat/screens/chat_screen.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.watch(chatControllerProvider).getChatList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
            String message = snapshot.data![index].lastMessage;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: {
                                'name': (snapshot.data![index].name),
                                'uid': (snapshot.data![index].contactId),
                              });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data![index].profilePic),
                            radius: 25,
                          ),
                          title: Text(
                            snapshot.data![index].name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            message.length > 20 ? "${message.substring(0,20)} ..." : message,
                            style: const TextStyle(fontSize: 16, letterSpacing: 1),
                            maxLines: 1,
                          ),
                          trailing: Text(
                            DateFormat.Hm()
                                .format(snapshot.data![index].timeSent),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
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
    );
  }
}
