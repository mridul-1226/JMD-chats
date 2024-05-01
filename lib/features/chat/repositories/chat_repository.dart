import 'dart:io';

import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/common/providers/message_reply_provider.dart';
import 'package:chatting_app/common/repository/common_firebase_storage_repository.dart';
import 'package:chatting_app/common/utils/utils.dart';
import 'package:chatting_app/models/chat_contact_model.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:chatting_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<MessageModel>> getMessages(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var doc in event.docs) {
        var message = MessageModel.fromMap(doc.data());
        messages.add(message);
      }
      return messages;
    });
  }

  Stream<List<ChatContactModel>> getChatList() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> chatList = [];

      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        chatList.add(ChatContactModel(
            name: user.name,
            profilePic: user.profilePic,
            lastMessage: chatContact.lastMessage,
            timeSent: chatContact.timeSent,
            contactId: user.uid));
      }

      return chatList;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
  ) async {
    //Message stored at receiver's end.
    var receiverChatContact = ChatContactModel(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        lastMessage: text,
        timeSent: timeSent,
        contactId: senderUserData.uid);

    await firestore
        .collection('users')
        .doc(receiverUserData.uid)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(
          receiverChatContact.toMap(),
        );

    //Message stored at sender's end.
    var senderChatContact = ChatContactModel(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        lastMessage: text,
        timeSent: timeSent,
        contactId: receiverUserData.uid);

    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserData.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection(
      {required String receiverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String username,
      required String receiverUsername,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required MessageEnum repliedMessageType}) async {
    final message = MessageModel(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? username
                : receiverUsername,
        repliedMessageType: repliedMessageType);

    //Messages at sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    //Messages at receiver
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required UserModel senderUserData,
      required String receiverUserId,
      required MessageReply? messageReply}) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          senderUserData, receiverUserData, text, timeSent);

      _saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          receiverUsername: receiverUserData.name,
          messageType: MessageEnum.text,
          messageReply: messageReply,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required UserModel senderUserData,
      required String receiverUserId,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReply? messageReply}) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      var fileUrl = await ref
          .read(commonFirebaseStorageProvider)
          .storeFileToFirebase(
              'chat/${senderUserData.uid}/$receiverUserId/${messageEnum.type}/$messageId',
              file);

      String fileContactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          fileContactMsg = '📷 Image';
          break;
        case MessageEnum.video:
          fileContactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          fileContactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          fileContactMsg = 'GIF';
          break;
        default:
          fileContactMsg = '';
      }

      _saveDataToContactsSubcollection(
          senderUserData, receiverUserData, fileContactMsg, timeSent);

      _saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          receiverUsername: receiverUserData.name,
          messageType: messageEnum,
          messageReply: messageReply,
          repliedMessageType: messageReply == null
              ? MessageEnum.image
              : messageReply.messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String gifUrl,
      required UserModel senderUserData,
      required String receiverUserId,
      required MessageReply? messageReply}) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          senderUserData, receiverUserData, gifUrl, timeSent);

      _saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: gifUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          receiverUsername: receiverUserData.name,
          messageType: MessageEnum.gif,
          messageReply: messageReply,
          repliedMessageType: messageReply == null
              ? MessageEnum.gif
              : messageReply.messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setMessageSeen(BuildContext context, String receiverUserId, String messageId) async {
    try {
      //Messages at sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen' : true});

    //Messages at receiver
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen' : true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
