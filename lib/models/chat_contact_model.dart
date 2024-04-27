// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatContactModel {
  final String name;
  final String profilePic;
  final String lastMessage;
  final DateTime timeSent;
  final String contactId;

  ChatContactModel({required this.name, required this.profilePic, required this.lastMessage, required this.timeSent, required this.contactId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'lastMessage': lastMessage,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'contactId': contactId,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      contactId: map['contactId'] ?? '',
    );
  }
}