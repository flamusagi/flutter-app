import 'package:flutter/material.dart';

import 'shared_data.dart';

class UpdatePasswordPage extends StatelessWidget {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String errorText = ''; // Error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码界面'),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          CustomTextField(
            labelText: '账号',
            controller: accountController,
          ),
          SizedBox(height: 40),
          CustomTextField(
            labelText: '旧密码',
            controller: oldPasswordController,
            isPassword: true,
          ),
          SizedBox(height: 40),
          CustomTextField(
            labelText: '新密码',
            controller: newPasswordController,
            isPassword: true,
          ),
          SizedBox(height: 20),
          Text(
            errorText,
            style: TextStyle(color: Colors.blueGrey),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final account = accountController.text;
              final oldPassword = oldPasswordController.text;
              final newPassword = newPasswordController.text;

              if (newPassword == oldPassword) {

                  errorText = '新密码不能与旧密码相同';


              } else {
                // Your password update logic here
                final success = await AccountInfoHelper.updateAccountPassword(account, newPassword);

                if (success) {
                  // Clear the input fields
                  oldPasswordController.clear();
                  newPasswordController.clear();

                    errorText = ''; // Clear any previous error message

                  // Navigate to another page or perform other actions
                  Navigator.of(context, rootNavigator: true).pushNamed("/");
                } else {

                    errorText = '密码更新失败'; // Display an error message

                }
              }
            },
            child: Text('确定'),
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
