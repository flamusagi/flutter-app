
import 'package:shared_preferences/shared_preferences.dart';
class AccountInfo {
  final String account;
  final String password;
  final String nickname;


  AccountInfo({
    required this.account,
    required this.password,
    required this.nickname,
  });
}


class AccountInfoHelper{
  // 获取用户数据
  static Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    final nickname = prefs.getString('nickname');

    if (username != null && password != null && nickname != null) {
      return {
        'username': username,
        'password': password,
        'nickname': nickname,
      };
    } else {
      return null;
    }
  }
  static Future<void> storeAccountData(String account, String password, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', account);
    await prefs.setString('password', password);
    await prefs.setString('nickname', nickname);
  }




  static Future<bool> updateAccountPassword(String account, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      await prefs.setString('password', newPassword);
      return true;
    }else{
      return false;
    }
  }
  static Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if(username!=null){
      final nickname = prefs.getString('nickname');
      return Future.value(nickname);
    }else {
      return Future.value(null);
    }
  }

  static Future<String> getPassword(bool isRemembered) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (isRemembered && username != null) {
      final password = prefs.getString('password');
      return Future.value(password);
    } else {
      return Future.value(null);
    }
  }

  static Future<String> getAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    return Future.value(username);
  }


  static Future<void> saveRemembered(bool isRemembered) async {
    final prefs = await SharedPreferences.getInstance();
    final value=prefs.setBool('status', isRemembered);
  }

  static Future<bool> loadRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    final value=prefs.getBool('status');
    return Future.value(value);
  }
}



