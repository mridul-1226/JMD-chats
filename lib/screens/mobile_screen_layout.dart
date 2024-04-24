import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/widgets/contact_list.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: tabColor,
          child: const Icon(Icons.add_comment, color: Colors.white,),
        ),
        appBar: AppBar(
          title: const Text(
            'JMD',
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          toolbarHeight: 38,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                )),
          ],
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text('CHATS'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text('STATUS'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text('CALLS'),
              ),
            ],
            indicatorColor: tabColor,
            indicatorWeight: 3,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: appBarColor,
          elevation: 0,
        ),
        body: const ContactList(),
      ),
    );
  }
}
