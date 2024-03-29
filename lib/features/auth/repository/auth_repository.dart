import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_ui/features/auth/repository/common_Firebase_storage_repository.dart';
import 'dart:io';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/screens/otp_screen.dart';
import 'package:whatsapp_ui/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(this.auth, this.firestore);

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
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
        codeSent: ((String verificationID, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationID);
        }),
        codeAutoRetrievalTimeout: (String VerificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationID,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamed(
        context,
        UserInformationScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('ProfilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupID: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),);
  }
}
