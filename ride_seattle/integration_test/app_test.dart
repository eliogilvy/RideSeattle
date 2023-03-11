

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ride_seattle/main.dart' as app;

void main() {
  group('app test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();


    testWidgets('full app test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      //final loginRegisterBtn = find.byKey(const ValueKey('login_or_registerButton'));
      //await tester.tap(loginRegisterBtn);
      //await tester.pumpAndSettle(const Duration(milliseconds: 300));

      //expect(find.text("Login instead"), findsOneWidget);

      final submit_loginRegisterBtn = find.byKey(const ValueKey('submit_login_Register_Button'));

      final emailField = find.byKey(const ValueKey("emailField"));
      final passwordField = find.byKey(const ValueKey("passwordField"));

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("emailField")), 'testEmail@test.com');
      await tester.enterText(find.byKey(const ValueKey("passwordField")), '123456789');
      await tester.pumpAndSettle();

      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle();

      //final googleMap = find.byKey(const ValueKey("googleMap"));
      //expect(googleMap, findsOneWidget);

    });


  });
}