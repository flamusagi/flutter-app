import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/login_register_data/loginpage.dart';
import 'package:untitled/login_register_data/register.dart';
import 'package:untitled/login_register_data/shared_data.dart';

void main() {
  group('User Registration and Login Tests', () {
    testWidgets('User registration test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: RegistrationPage(),
      ));

      // Find the TextFields by their labelText
      final accountTextField = find.widgetWithText(TextField, '账号');
      final passwordTextField = find.widgetWithText(TextField, '密码');
      final nicknameTextField = find.widgetWithText(TextField, '昵称');

      // Enter some text into the TextFields
      await tester.enterText(accountTextField, '1');
      await tester.enterText(passwordTextField, '1');
      await tester.enterText(nicknameTextField, '1');

      // Find and tap the '注册' button
      final registerButton = find.widgetWithText(ElevatedButton, '注册');
      await tester.tap(registerButton);

      // Rebuild the widget after tapping the button
      await tester.pump();
      // Build the widget tree with the LoginForm
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(),
        ),
      ));


      // Find the account and password text fields
      final accountTextFieldFinder = find.widgetWithText(TextFormField, '账号');
      final passwordTextFieldFinder = find.widgetWithText(TextFormField, '密码');

      // Find the login button
      final loginButtonFinder = find.byType(InkWell);

      // Enter a mock account and password
      await tester.enterText(accountTextFieldFinder, '1');
      await tester.enterText(passwordTextFieldFinder, '1');

      // Tap the login button
      await tester.tap(loginButtonFinder);
      await tester.pump();


    });
    testWidgets('Test login process in LoginForm', (WidgetTester tester) async {
      // Build the widget tree with the LoginForm
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(),
        ),
      ));


      // Find the account and password text fields
      final accountTextFieldFinder = find.widgetWithText(TextFormField, '账号');
      final passwordTextFieldFinder = find.widgetWithText(TextFormField, '密码');

      // Find the login button
      final loginButtonFinder = find.byType(InkWell);

      // Enter a mock account and password
      await tester.enterText(accountTextFieldFinder, '1');
      await tester.enterText(passwordTextFieldFinder, '1');

      // Tap the login button
      await tester.tap(loginButtonFinder);
      await tester.pump();

    });
    testWidgets('Test login functionality', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(),
        ),
      ));

      // Find widgets
      final accountTextFieldFinder = find.widgetWithText(TextFormField, '账号');
      final passwordTextFieldFinder = find.widgetWithText(TextFormField, '密码');
      final rememberPasswordCheckbox = find.byType(Checkbox);
      final eyeIconFinder = find.byType(IconButton);
      final loginButtonFinder = find.byType(InkWell);

      // Test Remember Password checkbox
      await tester.tap(rememberPasswordCheckbox);
      await tester.pump();
      //expect(LoginForm().isRemembered, true);

      // Enter incorrect password to trigger the validation logic
      await tester.enterText(accountTextFieldFinder, 'incorrect');
      await tester.enterText(passwordTextFieldFinder, 'incorrect');

      // Tap the login button
      await tester.tap(loginButtonFinder);
      await tester.pump();

      // Check if the input fields are cleared after an incorrect login attempt
      expect(accountTextFieldFinder, findsOneWidget);
      expect(passwordTextFieldFinder, findsOneWidget);


      // Toggle password visibility
      await tester.tap(eyeIconFinder);
      await tester.pump();
      expect(LoginForm().isVisible, true); // Password should be visible

      // Toggle password visibility again
      await tester.tap(eyeIconFinder);
      await tester.pump();
      expect(LoginForm().isVisible, false); // Password should be hidden again
    });
  });
}
