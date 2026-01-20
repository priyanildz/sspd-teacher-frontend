import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("authToken");
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(userData);
    await prefs.setString("userProfile", userJson);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString("userProfile");

    if (userProfile != null) {
      return jsonDecode(userProfile);
    }
    return null;
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
  }

  static Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? userProfile = prefs.getString("userProfile");

  if (userProfile != null) {
    Map<String, dynamic> userData = jsonDecode(userProfile);
    if (userData.containsKey("_id")) return userData["_id"];
  }

  return prefs.getString('user_id');
}


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> testUserId() async {
  String? userId = await AuthService.getUserId();
  print("🔥 Retrieved User ID: $userId");
}

  static Future<void> saveStd(String? std) async {
    final prefs = await SharedPreferences.getInstance();
    if (std != null) await prefs.setString('std', std);
  }

  static Future<void> saveClassName(String? className) async {
    final prefs = await SharedPreferences.getInstance();
    if (className != null) await prefs.setString('className', className);
  }

  static Future<String?> getStd() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('std');
  }

  static Future<String?> getClassName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('className');
  }


}
