import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import '../classes/auth.dart';
import '../classes/firebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(Auth auth) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword(Auth auth) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      userSetup();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Ride Seattle');
  }

  Widget _entryField(
      String title, TextEditingController controller, ValueKey key,
      {bool password = false}) {
    return TextField(
      key: key,
      obscureText: password,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _passwordField(String title, TextEditingController controller) {
    return TextField(
      key: const ValueKey("passwordField"),
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _emailField(String title, TextEditingController controller) {
    return TextField(
      key: const ValueKey("emailField"),
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error ? $errorMessage',
      key: const ValueKey('error_message'),
    );
  }

  Widget _submitButton(Auth auth) {
    return ElevatedButton(
      key: const ValueKey("submit_login_Register_Button"),
      onPressed: () {
        if (isLogin) {
          signInWithEmailAndPassword(auth);
        } else {
          createUserWithEmailAndPassword(auth);
        }
      },
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      key: const ValueKey("login_or_registerButton"),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/skyline.jpg'),
                fit: BoxFit.cover,
              )
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 140),
              Image.asset('assets/images/logo.png'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _emailField('Email', emailController),
                    _passwordField('Password', passwordController),
                    _errorMessage(),
                    _submitButton(fire.auth),
                    _loginOrRegisterButton(),
                  ],
                ),
              )
            ],
            ),
          ),
        ),
    );
  }
}
