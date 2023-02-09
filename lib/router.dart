import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_Screen.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/screens/otp_screen.dart';
import 'package:whatsapp_ui/widgets/error.dart';
import 'features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SelectContactsScreen());

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder: (context) => MobileChatScreen(name, uid));


    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) =>  OTPScreen(VerificationId: verificationId));

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page doesn\'nt exist!'),
              ));
  }
}
