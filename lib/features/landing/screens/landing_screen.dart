import 'package:chatting_app/common/widgets/custom_button.dart';
import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Welcome To JMD Chats',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: size.height / 7,
              ),
              Image.asset(
                'assets/landing.png',
                color: tabColor,
                width: size.width * 0.7,
              ),
              Expanded(
                child: SizedBox(
                  height: size.height / 7,
                ),
              ),
              SizedBox(
                width: size.width * 0.9,
                child: const Text(
                  'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Services.',
                  style: TextStyle(color: greyColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              SizedBox(
                width: size.width * 0.8,
                child:
                    CustomButton(text: 'AGREE AND CONTINUE', onPressed: () => navigateToLoginScreen(context)),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
