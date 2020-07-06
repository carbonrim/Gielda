import 'package:shared_preferences/shared_preferences.dart';

class LocalUserInfo {
  static String username = '';

  static bool isUsernameSet() {
    return username != '';
  }

  static Future<String> retrieveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    return username;
  }
}
