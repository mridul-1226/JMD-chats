import 'package:chatting_app/common/widgets/error_screen.dart';
import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-conatcts-screen';
  const SelectContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select conact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30,
                              ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
            error: (error, stackTrace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const LoadingScreen(),
          ),
    );
  }
}
