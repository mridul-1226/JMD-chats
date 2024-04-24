import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/responsive/responsive_layout.dart';
import 'package:chatting_app/screens/mobile_screen_layout.dart';
import 'package:chatting_app/screens/web_screen_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JMD Chats',
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    ),
  );
}
