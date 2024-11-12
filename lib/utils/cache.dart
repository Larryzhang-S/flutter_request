import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences? prefs;

  static initSP() async {
    prefs = await SharedPreferences.getInstance();
    log('本地初始化成功');
  }

  static String? get(String key) {
    return prefs?.getString(key);
  }

  static Future<void> remove(String key) async {
    await prefs?.remove(key);
  }

  static Future<void> save(String key, String value) async {
    await prefs?.setString(key, value);
  }

  static Future<String?> getToken() async {
    //使用本地存储缓存
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString("token") ?? "";
  }
}
