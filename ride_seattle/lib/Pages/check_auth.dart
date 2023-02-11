import 'package:flutter/material.dart';
import 'maps_screen.dart';
import 'login_screen.dart';
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
          return const MapScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
