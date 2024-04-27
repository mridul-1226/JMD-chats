import 'package:chatting_app/common/widgets/error_screen.dart';
import 'package:chatting_app/features/auth/screens/login_screen.dart';
import 'package:chatting_app/features/auth/screens/otp_screen.dart';
import 'package:chatting_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chatting_app/features/chat/screens/chat_screen.dart';
import 'package:chatting_app/screens/user_information_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      );
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: ((context) => OtpScreen(verificationId: verificationId)),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const UserInformationScreen()),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const SelectContactsScreen()),
      );
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: ((context) => ChatScreen(
              name: name,
              uid: uid,
            )),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
