import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chatpage.dart';


class FriendListItem extends StatelessWidget {
  final String friendName;
  final String avatarImagePath;
  final String latestMessage;
  final String lastChatDate; // 添加日期属性

  //java的类的构造方法
  FriendListItem({
    required this.friendName,
    required this.avatarImagePath,
    required this.latestMessage,
    required this.lastChatDate, // 接收日期属性
  });

  factory FriendListItem.fromJson(Map<String, dynamic> json) {
    return FriendListItem(
      friendName: json['friendName'],
      avatarImagePath: json['avatarImagePath'],
      latestMessage: json['latestMessage'],
      lastChatDate: json['lastChatDate'],
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatarImagePath),

        //backgroundImage: Image.network(avatarImagePath).image,
      ),
      title: Text(friendName),
      subtitle: Text(latestMessage),
      trailing: Text( // 放置日期文本到右侧 trailing
        lastChatDate,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        // 导航到聊天页面，并传递好友信息
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(friend: this),
          ),
        );
      },
    );
  }
}

//read json local file and return string
Future<String> loadJsonData() async  {
  final jsonString = await rootBundle.loadString('assets/friends.json');
  return jsonString;
}
//parse json string and use factory to get T class instances
List<T> parseData<T>(String json, T Function(Map<String, dynamic>) fromJson) {
  final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
  return parsed.map<T>(fromJson).toList();
}

Future<Widget> buildChatList() async {
  final json = await loadJsonData();
  final List<FriendListItem> friends = parseData(json,FriendListItem.fromJson);
  return ListView.builder(
    itemCount: friends.length,
    itemBuilder: (BuildContext context, int index) {
      // 使用自定义的FriendListItem组件来构建好友列表项
      return FriendListItem(
        friendName: friends[index].friendName,
        avatarImagePath: friends[index].avatarImagePath,
        latestMessage: friends[index].latestMessage,
        lastChatDate: friends[index].lastChatDate,
      );
    },
  );
}