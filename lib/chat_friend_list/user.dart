import 'package:untitled/login_register_data/shared_data.dart';

class User {
  final String nickname;
  final String avatarImageUrl;

  User({
    required this.nickname,
    required this.avatarImageUrl,
  });

}

User currentUser = User (
    nickname: '增本绮良',
    avatarImageUrl: 'images/60.jpg',
);
