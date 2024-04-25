import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/screens/otp_screen.dart';
import 'package:chatting_app/features/landing/screens/landing_screen.dart';
import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JMD Chats',
        home: const OtpScreen(verificationId: '445',),
        onGenerateRoute: (settings) => generateRoute(settings),
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
      ),
    ),
  );
}
