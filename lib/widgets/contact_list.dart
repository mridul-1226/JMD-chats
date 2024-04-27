import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/data/info.dart';
import 'package:chatting_app/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen(name: 'ABC', uid: '1234',),));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(info[index]['profilePic'].toString()),
                      radius: 25,
                    ),
                    title: Text(info[index]['name'].toString(), style: const TextStyle(fontSize: 18),),
                    subtitle: Text(info[index]['message'].toString(), style: const TextStyle(fontSize: 14),),
                    trailing: Text(info[index]['time'].toString(), style: const TextStyle(color: Colors.grey),),
                  ),
                ),
              ),
              const Divider(color: dividerColor, indent: 85,)
            ],
          );
        },
      ),
    );
  }
}
