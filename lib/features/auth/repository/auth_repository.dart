import 'dart:io';

import 'package:chatting_app/common/repository/common_firebase_storage_repository.dart';
import 'package:chatting_app/common/utils/utils.dart';
import 'package:chatting_app/features/auth/screens/otp_screen.dart';
import 'package:chatting_app/models/user_model.dart';
import 'package:chatting_app/screens/mobile_screen_layout.dart';
import 'package:chatting_app/screens/user_information_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  },
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OtpScreen.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase(
      {required BuildContext context,
      required String name,
      required File? profilePic,
      required ProviderRef ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://cdn-icons-png.flaticon.com/512/1077/1077114.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          phoneNumber: auth.currentUser!.phoneNumber!,
          isOnline: true,
          groupId: []);

      firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }
}
