import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'animedetail.dart';



class AnimeItem extends StatelessWidget {
  final String url;
  final String name;
  final Map<String, dynamic> images;
  static int currentPage = 1;


  AnimeItem({required this.url, required this.name, required this.images});

  factory AnimeItem.fromJson(Map<String, dynamic> json) {
    return AnimeItem(
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      images: json['images'] ?? {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // 在这里构建 AnimeItem 的外观，使用从 JSON 数据中获取的属性
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 10.0),

          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),
          ),
          Divider(height: 5.0),
          Text(
            url,
            style: TextStyle(color: Colors.grey,fontSize: 14),
          ),
          Divider(height: 2.0),
        ],
      ),
      leading: Container(
        width: 100, // 设置宽度，根据需要调整大小
        height: 150, // 设置高度，根据需要调整大小

        child:(images['medium'] != null &&(Uri.parse(images['medium']).isScheme("http") || Uri.parse(images['medium']).isScheme("https")))
            ? CachedNetworkImage(
          imageUrl: images['medium'] ?? '',fit: BoxFit.fitWidth,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        )
            : Image.asset('images/failed.jpg'),
      ),
      onTap: () {
        // 当用户点击新闻时，你可以在这里处理跳转到详细页面的逻辑
        // 使用 Navigator.push 跳转到详细页面，并传递必要的参数
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailPage(
              url: url,
              // 其他参数
            ),
          ),
        );
      },

    );
  }
}

//final List<dynamic> dataList = json.decode(jsonData); // 解析 JSON 数组
//final Map<String, dynamic> dataList = json.decode(jsonData); // 解析 JSON 对象

Future<List<AnimeItem>> loadJsonData(int page) async {
  final response = await http.get(Uri.parse('https://api.bgm.tv/calendar'));
  Utf8Decoder decode = new Utf8Decoder();
  final List<dynamic> result = jsonDecode(decode.convert(response.bodyBytes));
  final List<dynamic> items = result[page]['items'];
  final List<AnimeItem> animeItems = items.map((item) => AnimeItem.fromJson(item)).toList();

  return animeItems;
}



Future<Widget> buildAnimeList() async  {

  final List<AnimeItem> AnimeItems = await loadJsonData(AnimeItem.currentPage-1);
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          itemExtent: 120.0, // 设置每个列表项的高度，调整这个值来控制高度
          itemCount: AnimeItems.length,
          itemBuilder: (BuildContext context, int index) {
            // 使用自定义的AnimeItem组件来构建动画列表项
            return AnimeItem(
              url: AnimeItems[index].url,
              name: AnimeItems[index].name,
              images: AnimeItems[index].images,
            );
          },
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Text(
          '当前页数: ${AnimeItem.currentPage}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    ],
  );

}


