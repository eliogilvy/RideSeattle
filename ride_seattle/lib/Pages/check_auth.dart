import 'package:flutter/material.dart';
import '../Pages/ride_homeScreen.dart';
import '../Pages/home_page.dart';
import '../classes/auth.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ride_homeScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
