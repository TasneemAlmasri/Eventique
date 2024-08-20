import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  // Save data based on its type
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  // Read data from shared preferences
  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key); // This returns the dynamic type
  }

  // Delete data from shared preferences
  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  // Save user data as key-value pairs
  static Future<void> saveUserData(
    int userId,
    String loginToken,
    String firebaseToken,
    String userName,
    String userEmail,
  ) async {
    await saveData('userId', userId);
    await saveData('loginToken', loginToken);
    await saveData('firebaseToken', firebaseToken);
    await saveData('userName', userName);
    await saveData('userEmail', userEmail);
  }

  // Load user data
  static Future<Map<String, dynamic>> loadUserData() async {
    int? userId = await readData('userId');
    String? loginToken = await readData('loginToken');
    String? firebaseToken = await readData('firebaseToken');
    String? userName = await readData('userName');
    String? userEmail = await readData('userEmail');

    return {
      'userId': userId,
      'loginToken': loginToken,
      'firebaseToken': firebaseToken,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  // Update specific user data fields
  static Future<void> updateUserData({
    int? userId,
    String? loginToken,
    String? firebaseToken,
    String? userName,
    String? userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setInt('userId', userId);
    }
    if (loginToken != null) {
      await prefs.setString('loginToken', loginToken);
    }
    if (firebaseToken != null) {
      await prefs.setString('firebaseToken', firebaseToken);
    }
    if (userName != null) {
      await prefs.setString('userName', userName);
    }
    if (userEmail != null) {
      await prefs.setString('userEmail', userEmail);
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('loginToken');
    await prefs.remove('firebaseToken');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
  }
}
