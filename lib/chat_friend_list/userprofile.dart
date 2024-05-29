import 'package:flutter/material.dart';
import 'user.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人资料'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(currentUser.avatarImageUrl),
            ),
            SizedBox(height: 10),
            Text(
              currentUser.nickname,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'こんにちは、増本綺良です!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 80.0),
            buildListTile(Icons.chat, '消息管理', () {
            }),
            buildListTile(Icons.photo, '我的相册', () {
            }),
            buildListTile(Icons.folder, '我的文件', () {
            }),
            buildListTile(Icons.headset_mic, '联系客服', () {
            }),
            buildListTile(Icons.delete, '清理缓存', () {
            }),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, Function() onTap) {
    return Center(
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon), // 左侧图标
            title: Text(title),
            onTap: onTap,
          ),
          Divider(),
        ],
      ),
    );
  }
}
