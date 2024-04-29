import 'package:chatting_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<List<dynamic>>> getContacts() async {
    List<Contact> contacts = [];
    List<Contact> availableContacts = [];
    List<UserModel> users = [];
    var userCollection = await firestore.collection('users').get();
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);

        // for (var document in userCollection.docs) {
        //   Contact? availContact;
        //   var userData = UserModel.fromMap(document.data());
        //   if (contacts.any((contact) {
        //     availContact = contact;
        //     String selectedPhone = contact.phones[0].number
        //         .toString()
        //         .replaceAll('(', '')
        //         .replaceAll(')', '')
        //         .replaceAll(' ', '')
        //         .replaceAll('-', '');
        //     return selectedPhone.contains(userData.phoneNumber) ||
        //         userData.phoneNumber.contains(selectedPhone);
        //   })) {
        //     availableContacts.add(availContact!);
        //   }
        // }
        for (var contact in contacts) {
          UserModel? userData;
          if (userCollection.docs.any((document) {
            userData = UserModel.fromMap(document.data());
            String selectedPhone = contact.phones[0].number
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll(' ', '')
                .replaceAll('-', '');
            return selectedPhone.contains(userData!.phoneNumber) ||
                userData!.phoneNumber.contains(selectedPhone) || selectedPhone == userData!.phoneNumber;
          })) {
            availableContacts.add(contact);
            users.add(userData!);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [availableContacts, users];
  }
}
