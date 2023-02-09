import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/landing/Screens/landing_Screen.dart';
import 'package:whatsapp_ui/router.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/common/widget/loader.dart';
import 'package:whatsapp_ui/screens/web_layout_screen.dart';
import 'package:whatsapp_ui/utils/responsive_layout.dart';
import 'package:whatsapp_ui/widgets/error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(color: appBarColor),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LandingScreen();
                }
                return const MobileLayoutScreen();
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            )
        // const ResponsiveLayout(
        //   mobileScreenLayout: MobileLayoutScreen(),
        //   webScreenLayout: WebLayoutScreen(),
        // ),
        );
  }
}
