import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/chat/controller/chat_controller.dart';
import 'package:chatting_app/features/chat/screens/chat_screen.dart';
import 'package:chatting_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:chatting_app/screens/user_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).updateUserState(true);
        break;
      default:
        ref.read(authControllerProvider).updateUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.add_comment,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'JMD',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: false,
          toolbarHeight: 38,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.grey,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserInformationScreen.routeName);
                },
                icon: const Icon(
                  Icons.person,
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
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: StreamBuilder<List<ChatContactModel>>(
              stream: ref.watch(chatControllerProvider).getChatList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                return ListView.builder(
                  shrinkWrap: false,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
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
      ),
    );
  }
}
