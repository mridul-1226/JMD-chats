import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  void verifyOtp(BuildContext context, String userOTP, WidgetRef ref){
    ref.read(authControllerProvider).verifyOtp(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('We have sent a SMS with a code'),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(fontSize: 30),
                  ),
                  maxLength: 6,
                  onChanged: (value) {
                    if(value.length == 6){
                      verifyOtp(context, value.trim(), ref);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
