import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});




class AuthController{
  final ProviderRef ref;
  final AuthRepository authRepository;
  AuthController({ required this.authRepository, required this.ref});

  void signInWithPhone(BuildContext context, String phoneNumber){
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationID, String userOTP){
    authRepository.verifyOTP(context: context, verificationID: verificationID, userOTP: userOTP);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic){
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, ref: ref, context: context);
  }
  Stream<UserModel> userDataById(String userId){
    return authRepository.userData(userId);
  }
}