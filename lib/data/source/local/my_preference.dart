import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref{
  static late final SharedPreferences _preferences;
  static void init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static void saveLocal(String username) {
    _preferences.setString("username", username);
  }

  static String? getLocal() {
    return _preferences.getString("username");
  }
}