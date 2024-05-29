
import 'package:flutter/material.dart';
import '../chat_friend_list/user.dart';
import '../chat_friend_list/userprofile.dart';
import '../content_list/bangumi.dart';
import '../content_list/quote.dart';
import '../login_register_data/loginpage.dart';
import '../content_list/newslist.dart';
import '../chat_friend_list/chatpage.dart';
import '../chat_friend_list/friendlist.dart';
import 'bottom.dart';


Map<String, Future<Widget>> currentItems = {
  'news': Future.value(buildNewsList()),
  'anime': Future.value(buildAnimeList()),
};
Future<Widget>? getBody(String key) {
  if (currentItems.containsKey(key)) {
    if (key == 'news') {
      return Future.value(buildNewsList());
    } else if (key == 'anime') {
      return Future.value(buildAnimeList());
    }
  }
  print("未找到key，所以value为空");
  return null;
}
Future<Widget>? currentBody = getBody('news');
enum KeyItem { news, anime }
KeyItem currentKey=KeyItem.news;

class News extends StatefulWidget {

  News({Key? key}) : super(key: key);

  _NewsState createState() => _NewsState();
}


class _NewsState extends State<News> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<Widget>(
        future: currentBody,
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

          onSelected: (String choice) async {
            switch (choice) {
              case '下一页':
                if(currentKey==KeyItem.news){
                  NewsItem.currentPage++;
                  currentBody=getBody('news');
                }else if(currentKey==KeyItem.anime){
                  if(AnimeItem.currentPage<8){
                    AnimeItem.currentPage++;
                    currentBody=getBody('anime');

                  }
                }
                Navigator.of(context, rootNavigator: true).pushNamed("/News");

                break;
              case '上一页':
                if(currentKey==KeyItem.news){
                  if(NewsItem.currentPage>1){
                    NewsItem.currentPage--;
                    currentBody=getBody('news');
                  }
                }else if(currentKey==KeyItem.anime){
                  if(AnimeItem.currentPage-1>0){
                    AnimeItem.currentPage--;
                    currentBody=getBody('anime');
                  }
                }
                Navigator.of(context, rootNavigator: true).pushNamed("/News");
                break;
              case '看动画':
                currentBody=getBody('anime');
                currentKey=KeyItem.anime;
                Navigator.of(context, rootNavigator: true).pushNamed("/News");
                break;
              case '看新闻':
                currentBody=getBody('news');
                currentKey=KeyItem.news;

                Navigator.of(context, rootNavigator: true).pushNamed("/News");
                break;
              case '英语格言':
                final quote = await Quote.loadJsonData();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(quote.en),
                      content: Text(quote.zh),
                      actions: <Widget>[
                        TextButton(
                          child: Text('我知道了'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // 关闭对话框
                          },
                        ),
                      ],
                    );
                  },
                );
                break;

            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[

              PopupMenuItem<String>(
                value: '下一页',
                child: Text('下一页'),
              ),
              PopupMenuItem<String>(
                value: '上一页',
                child: Text('上一页'),
              ),
              PopupMenuItem<String>(
                value: '看动画',
                child: Text('看动画'),
              ),
              PopupMenuItem<String>(
                value: '看新闻',
                child: Text('看新闻'),
              ),
              PopupMenuItem<String>(
                value: '英语格言',
                child: Text('英语格言'),
              ),

              // 添加更多菜单项
            ];
          },
        ),
      ],

    );
  }

}





