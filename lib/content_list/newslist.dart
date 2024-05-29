import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'bangumi.dart';
import 'imagedownload.dart';
import 'quote.dart';

import 'newdetail.dart';
import 'newsdataBase.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsItem extends StatelessWidget{
  final String id;
  final String ctime;
  final String title;
  final String description;
  final String source;
  final String picUrl;
  final String url;
  static int currentPage = 1;

  NewsItem({
    required this.id,
    required this.ctime,
    required this.title,
    required this.description,
    required this.source,
    required this.picUrl,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'ctime': ctime,
      'title': title,
      'description': description,
      'source': source,
      'picUrl': picUrl,
      'url': url,
    };
  }

  factory NewsItem.fromMap(Map<String, dynamic> map) {
    return NewsItem(
      id: map['id'],
      ctime: map['ctime'],
      title: map['title'],
      description: map['description'],
      source: map['source'],
      picUrl: map['picUrl'],
      url: map['url'],
    );
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      ctime: json['ctime'],
      title: json['title'],
      description: json['description'],
      source: json['source'],
      picUrl: json['picUrl'],
      url: json['url'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0), // 可以取消默认内边距

      leading: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.open_in_new),
                    title: Text('在新标签页中打开图片'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDetailPage(picUrl: picUrl),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('下载图片'),
                    onTap: () {
                      downloadImage(picUrl);
                    },
                  ),
                ],
              );
            },
          );
        },
        // child: Uri.parse(picUrl).isScheme("http") || Uri.parse(picUrl).isScheme("https")
        //     ? Image.network(picUrl)
        //     : Image.asset('images/1.jpg'),
        child:(picUrl != null &&(Uri.parse(picUrl).isScheme("http") || Uri.parse(picUrl).isScheme("https")))
            ? CachedNetworkImage(
          imageUrl: picUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        )
            : Image.asset('images/failed.jpg'), // 替换为您的默认图片路径

      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 10.0),

          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18),
          ),
          Divider(height: 5.0),
          Text(
            ctime,
            style: TextStyle(color: Colors.grey,fontSize: 14),
          ),
          Divider(height: 2.0),
        ],
      ),
      onTap: () {
        // 当用户点击新闻时，你可以在这里处理跳转到详细页面的逻辑
        // 使用 Navigator.push 跳转到详细页面，并传递必要的参数
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: title,
              url: url,
              // 其他参数
            ),
          ),
        );
      },
    );

  }

}
class NewsItemHelper{
  Future<List<NewsItem>> loadJsonData(int page) async {
    /**
     * 字节流->字符串->Map(json作为数据格式) 把它想成数组使用即可
     */
    final response = await http.get(Uri.parse('https://apis.tianapi.com/sicprobe/index?key=fef7d2274f106e25e6883e21f62b77af&num=10&page=$page'));
    Utf8Decoder decode = new Utf8Decoder();
    Map<String, dynamic> result = jsonDecode(decode.convert(response.bodyBytes));
    /**
     * 这一行从解析后的 JSON 数据中提取了一个键为 'result' 的子对象，
     * 然后从该子对象中提取了一个键为 'newslist' 的数组。
     * 然后，使用 map 函数遍历这个数组，将每个元素转换为自定义类型 NewsItem 的实例。
     * 最后，将得到的对象列表转换为一个 Dart List。
     */
    List<NewsItem> datas = result['result']['newslist'].map<NewsItem>((item) => NewsItem.fromJson(item)).toList();
    // 获取第一个 newslist 中的 id 值
    //   String firstId = jsonData['result']['newslist'][0]['id'];
    return datas;
  }

  Future<void> saveNewsList(List<NewsItem> newsItems) async {
    final dbHelper = NewsDatabaseHelper();
    for (var news in newsItems) {
      await dbHelper.insertNews(news);
    }
  }

  Future<List<NewsItem>> loadNewsList() async {
    final dbHelper = NewsDatabaseHelper();
    return await dbHelper.getAllNews();
  }
  // 获取指定页数的新闻数据
  Future<List<NewsItem>> loadNewsByPage(int page) async {
    final dbHelper = NewsDatabaseHelper();
    // 检查数据库是否包含指定页数的新闻数据
    final newsList = await dbHelper.getNewsByPage(page);
    if (newsList.isNotEmpty) {
      return newsList; // 直接从数据库中获取数据
    } else {
      // 从网络获取数据
      final newsItems = await loadJsonData(page);
      // 保存到数据库
      await saveNewsList(newsItems);
      return newsItems;
    }
  }
}



Future<Widget> buildNewsList() async {
  final dbHelper = NewsDatabaseHelper();
  final newsHelper=NewsItemHelper();
  // 获取当前页数的新闻数据
  final newsItems = await newsHelper.loadNewsByPage(NewsItem.currentPage);

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          //itemExtent: 120.0,
          itemCount: newsItems.length,
          itemBuilder: (BuildContext context, int index) {
            return NewsItem(
              id: newsItems[index].id,
              ctime: newsItems[index].ctime,
              title: newsItems[index].title,
              description: newsItems[index].description,
              source: newsItems[index].source,
              picUrl: newsItems[index].picUrl,
              url: newsItems[index].url,
            );
          },
        ),
      ),
      // 显示当前页数的部件
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Text(
          '当前页数: ${NewsItem.currentPage}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}




