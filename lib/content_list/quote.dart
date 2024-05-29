import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'newslist.dart';

import 'newdetail.dart';

//const String url='https://apis.tianapi.com/enmaxim/index?key=fef7d2274f106e25e6883e21f62b77af';
class Quote extends StatelessWidget{

  final String en;
  final String zh;
  static String url='https://apis.tianapi.com/enmaxim/index?key=fef7d2274f106e25e6883e21f62b77af';


  Quote({
    required this.en, required this.zh,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      en: json['en'], zh: json['zh'],
    );
  }
  static Future<Quote> loadJsonData() async {
    final response = await http.get(Uri.parse(url));
    Utf8Decoder decode = const Utf8Decoder();
    Map<String, dynamic> result = jsonDecode(decode.convert(response.bodyBytes));
    final quote = Quote.fromJson(result['result']);
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextButton(
        child: Text('Show Quote',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(en),
                content: Text(zh),
                actions: <Widget>[
                  TextButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // 关闭对话框
                    },
                  ),
                ],
              );
            },
          );
        },

      ),


    );

  }
}


