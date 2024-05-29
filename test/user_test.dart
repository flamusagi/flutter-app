import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/chat_friend_list/user.dart';
import 'package:untitled/myapp_states/body.dart';
import 'package:untitled/myapp_states/main.dart';

void main() {
  testWidgets('Test user avatar and username in News page', (WidgetTester tester) async {
    // Mock user data
    final String mockAvatarImageUrl = currentUser.avatarImageUrl;
    final String mockUsername = currentUser.nickname;

    // Build the widget tree with the News page
    await tester.pumpWidget(MaterialApp(
      home: Home(),
    ));

    // Find the user avatar in the AppBar
    final userAvatarFinder = find.byType(CircleAvatar);
    expect(userAvatarFinder, findsOneWidget);

    // Find the username text in the AppBar
    final usernameTextFinder = find.text(mockUsername);
    expect(usernameTextFinder, findsOneWidget);
  });
}
