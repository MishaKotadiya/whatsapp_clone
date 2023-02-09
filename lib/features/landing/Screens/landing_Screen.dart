import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widget/custom_button.dart';
import 'package:whatsapp_ui/features/auth/screens/login_Screen.dart';

class LandingScreen extends StatelessWidget {

  void navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context, LoginScreen.routename);
  }
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Welcome to Whatsapp',
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Image.asset(
              'images/bg.png',
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: const Text(
                'Tap \"Agree & continue\" to accept the Whatsapp Terms of Service and Privacy Policy',
                style: TextStyle(
                  color: greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () {
                    navigateToLoginScreen(context);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
