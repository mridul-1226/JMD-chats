import 'package:chatting_app/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  return AuthController(
    authRepository: ref.watch(
      authRepositoryProvider,
    ),
  );
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOtp({required BuildContext context, required String verificationId, required String userOTP}) {
    authRepository.verifyOtp(context: context, verificationId: verificationId, userOTP: userOTP);
  }
}
