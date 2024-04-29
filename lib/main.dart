import 'package:chatting_app/common/widgets/error_screen.dart';
import 'package:chatting_app/common/widgets/loading_screen.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:chatting_app/features/landing/screens/landing_screen.dart';
import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/router.dart';
import 'package:chatting_app/screens/mobile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JMD Chats',
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileScreenLayout();
            },
            error: (error, stackTrace) {
              return ErrorScreen(
                error: error.toString(),
              );
            },
            loading: () => const LoadingScreen(),
          ),
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    );
  }
}
