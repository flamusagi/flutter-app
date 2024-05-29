//https://images.unsplash.com/ 图片地址
import 'package:flutter/material.dart';

import 'login_register_data/loginpage.dart';
import 'myapp_states/body.dart';
import 'myapp_states/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: '/', // 设置初始路由
      routes: {
        '/': (context) => StartLogin(),
        // 登录界面
        '/Home': (context) => Home(), // 主界面
        '/News': (context) => News(), // 主界面

      },
    );
  }
}