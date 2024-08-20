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
      String signUpToken,
      String loginToken,
      String firebaseToken,
      String userName,
      String userEmail,
      String userImage) async {
    await saveData('userId', userId);
    await saveData('signUpToken', signUpToken);
    await saveData('loginToken', loginToken);
    await saveData('firebaseToken', firebaseToken);
    await saveData('userName', userName);
    await saveData('userEmail', userEmail);
    await saveData('userImage', userImage);
  }

  // Load user data
  static Future<Map<String, dynamic>> loadUserData() async {
    int? userId = await readData('userId');
    String? signUpToken = await readData('signUpToken');
    String? loginToken = await readData('loginToken');
    String? firebaseToken = await readData('firebaseToken');
    String? userName = await readData('userName');
    String? userEmail = await readData('userEmail');
    String? userImage = await readData('userImage');

    return {
      'userId': userId,
      'signUpToken': signUpToken,
      'loginToken': loginToken,
      'firebaseToken': firebaseToken,
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage,
    };
  }

  // Update specific user data fields
  static Future<void> updateUserData({
    int? userId,
    String? signUpToken,
    String? loginToken,
    String? firebaseToken,
    String? userName,
    String? userEmail,
    String? userImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setInt('userId', userId);
    }
    if (signUpToken != null) {
      await prefs.setString('signUpToken', signUpToken);
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
    if (userImage != null) {
      await prefs.setString('userImage', userImage);
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    //await prefs.remove('signUpToken');
    await prefs.remove('loginToken');
    await prefs.remove('firebaseToken');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userImage');
  }
}
