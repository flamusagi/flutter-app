import 'package:flutter/material.dart';

import 'shared_data.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册'),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          CustomTextField(
            labelText: '账号',
            controller: accountController, // 传递控制器
          ),
          SizedBox(height: 40),

          CustomTextField(
            labelText: '密码',
            controller: passwordController, // 传递控制器
            isPassword: true,
          ),
          SizedBox(height: 40),
          CustomTextField(
            labelText: '昵称',
            controller: nicknameController, // 传递控制器
          ),

          ElevatedButton(
            onPressed: () async {
              final account = accountController.text;
              final password = passwordController.text;
              final nickname = nicknameController.text;

              // 在这里添加注册逻辑，处理用户注册的操作

              // 将新帐户信息添加到SharedPreferences中
             await AccountInfoHelper.storeAccountData(account, password, nickname);

              // 导航到其他页面或执行其他操作
              Navigator.of(context, rootNavigator: true).pushNamed("/");

            },
            child: Text('注册'),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller; // 添加控制器

  CustomTextField({
    required this.labelText,
    this.isPassword = false,
    required this.controller, // 接受控制器作为参数
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
      obscureText: isPassword,
    );
  }
}
