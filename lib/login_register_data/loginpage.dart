import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'register.dart';

import '../myapp_states/main.dart';
import 'updatepassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_data.dart';
void main(){
  runApp(MaterialApp(
    home: StartLogin(),
  ));

}
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
  bool get isRemembered => _LoginFormState().isRemembered;
  bool get isVisible => _LoginFormState().isVisible;
}

class _LoginFormState extends State<LoginForm>{
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isRemembered=false;
  Future<bool> validCheck() async {
    // // 获取输入框中的账号和密码
    String enteredAccount = accountController.text;
    String enteredPassword = passwordController.text;

    // 在这里执行账号密码验证，例如从存储的用户数据中获取账号和密码进行比对
    Map<String, String>? userData = await AccountInfoHelper.getUserData(); // 假设getUserData函数用于获取用户数据
    if (userData != null && userData['username'] == enteredAccount && userData['password'] == enteredPassword) {
      // 账号和密码匹配
      return true;
    } else {
      // 账号和密码不匹配，清空输入栏
      accountController.clear();
      passwordController.clear();
      return false;
    }

  }
  Future<void> updateAccountText() async {
    String? account = await AccountInfoHelper.getAccount();
    if (account != null) {
      accountController.text = account;
    }
  }
  Future<void> updatePasswordText() async {
    isRemembered =await AccountInfoHelper.loadRemembered();
    String? password =await AccountInfoHelper.getPassword(isRemembered);
    if (password != null) {
      passwordController.text=password;
    }
  }


  @override
  Widget build(BuildContext context) {
    updateAccountText();
    updatePasswordText();
    return Column(

      children: <Widget>[
        // 账号输入框
        TextFormField(
          controller: accountController,
          decoration: InputDecoration(
            hintText: '请输入账号',
            labelText: '账号',
            filled: true, // 启用填充
            fillColor: Colors.grey[200], // 填充颜色
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none, // 移除默认边框
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          ),
          textDirection: TextDirection.rtl,
          maxLines: 1,
        ),
        SizedBox(height: 16.0),

        // 密码输入框
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: '请输入密码',
            labelText: '密码',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),


          ),
          textDirection: TextDirection.rtl,
          obscureText: !isVisible,
          maxLines: 1,

        ),

        SizedBox(height: 20.0),
        // 记住密码checkbox

        Row(

          children: [


            Checkbox(
              value: isRemembered,
              onChanged: (value) {
                setState(() {
                  print("already remembered");
                  isRemembered=value!;
                  AccountInfoHelper.saveRemembered(isRemembered);
                });
              },
              activeColor: Colors.blueGrey,
              checkColor: Colors.blue,
            ),

            Text('记住密码'),
          ],
        ),
        // 登录按钮
        InkWell(
          onTap: () async {
            if (await validCheck()) {
              Navigator.of(context, rootNavigator: true).pushNamed("/Home");
            }
          },
          borderRadius: BorderRadius.circular(20.0), // 圆形按钮
          child: Ink(
          decoration: BoxDecoration(
          color: Colors.blue, // 蓝色背景色
          shape: BoxShape.circle, // 圆形
          ),
          child: Padding(
              padding: const EdgeInsets.all(20.0), // 调整箭头的位置
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white, // 箭头颜色
                size: 20.0, // 箭头大小
              ),
           ),
          ),

        )
      ],
    );
  }
}

class StartLogin extends StatefulWidget {
  @override
  _StartLoginState createState() => _StartLoginState();
}

// 在原始的MyApp类中使用LoginForm
class _StartLoginState extends State {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false; // 初始状态为未勾选
    return MaterialApp(
      title: 'QQ',
      home: Scaffold(
        appBar: AppBar(
          title: Text('QQ'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // QQ 图片
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'images/qq.jpg',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0), // 间距

                // 使用封装的LoginForm小部件
                LoginForm(),

                SizedBox(height: 340.0),

                Text.rich(
                  TextSpan(
                      text: '登录即代表同意并阅读',
                      style: TextStyle(fontSize: 15, color: Color(0xFF999999)),
                      children: [
                        TextSpan(
                          text: '《服务协议》',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('提示'),
                                    content: Text('你已阅读协议'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('确定'),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // 关闭对话框
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                        ),
                      ]),
                ),
                SizedBox(height: 5.0),

                // 底部链接文字
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdatePasswordPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 5),
                          Text('修改密码',
                              style: TextStyle(color: Color(0xFF999999))
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        // 点击"新用户注册"时导航到注册页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.person_add),
                          SizedBox(width: 5),
                          Text('新用户注册', style: TextStyle(color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.more_horiz),
                        SizedBox(width: 5),
                        Text('更多选项',style: TextStyle(color: Color(0xFF999999))),
                      ],
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}





