import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'maps_screen.dart';
import 'login_screen.dart';
import '../classes/auth.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

//TODO hide password when its being typed in
//TODO register show requirements in a hint text or label

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    return StreamBuilder(
      stream: fire.auth.authStateChanges,
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
