import 'package:flutter/material.dart';
import '../Pages/current_location_screen.dart';
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
          return const CurrentLocationScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
