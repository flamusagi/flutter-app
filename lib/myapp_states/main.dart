
import 'package:flutter/material.dart';
import '../chat_friend_list/user.dart';
import '../chat_friend_list/userprofile.dart';
import '../content_list/bangumi.dart';
import '../content_list/quote.dart';
import '../login_register_data/loginpage.dart';
import '../content_list/newslist.dart';
import '../chat_friend_list/chatpage.dart';
import '../chat_friend_list/friendlist.dart';
import 'body.dart';
import 'bottom.dart';




class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<Widget>(
        future: buildChatList(),
        initialData: CircularProgressIndicator(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');

              //throw Exception('Error: ${snapshot.error}');
              // 或者只抛出异常并注释掉上面的打印语句
              throw snapshot.stackTrace!;
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

          }
          return CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              // 点击用户头像时导航到用户个人资料页面
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(), // 用户个人资料页面
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(currentUser.avatarImageUrl), // QQ头像
            ),
          ),
          SizedBox(width: 10),
          Text(
            currentUser.nickname,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout), // 使用退出图标，你可以自定义图标
          onPressed: () {
            // 在这里执行退出操作，可能是返回到初始界面
            // 你可以使用Navigator来返回到初始界面
            Navigator.of(context, rootNavigator: true).pushNamed("/");
          },
        ),
        IconButton(
          icon: Icon(Icons.account_box),
          onPressed: (){
          },),
        PopupMenuButton<String>(
          icon: Icon(Icons.add),


          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '1',
                child: Text('加好友/群'),
              ),
              PopupMenuItem<String>(
                value: '2',
                child: Text('创建群聊'),
              ),
            ];
          },
        ),
      ],

    );
  }
}






