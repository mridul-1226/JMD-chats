import 'package:chatting_app/widgets/chat_list.dart';
import 'package:chatting_app/widgets/contact_list.dart';
import 'package:chatting_app/widgets/web_input_message.dart';
import 'package:chatting_app/widgets/web_chat_appbar.dart';
import 'package:chatting_app/widgets/web_profile_bar.dart';
import 'package:chatting_app/widgets/web_search_bar.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WebProfileBar(),
                  WebSearchBar(),
                  ContactList(),
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
                Expanded(child: ChatList()),
                InputMessage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
