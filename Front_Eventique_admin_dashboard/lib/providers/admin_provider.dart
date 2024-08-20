import 'dart:convert';
import 'package:eventique_admin_dashboard/shared_preferencess/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/main.dart';

class AdminProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  String _loginToken = '';
  String _firebaseToken = '';
  int _adminId = 0;
  var _adminData = {
    'name': '',
    'email': '',
  };

  String get fireToken {
    if (_firebaseToken.isNotEmpty) {
      return _firebaseToken;
    }
    return '';
  }

  AdminProvider() {
    _loadUserData();
  }

  String get token {
    if (_loginToken.isNotEmpty) {
      return _loginToken;
    }
    return '';
  }

  int get adminId {
    if (_adminId != 0) {
      return _adminId;
    }
    return -1;
  }

  Map<String, String> get adminData {
    return {..._adminData};
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> loadUserData() async {
    final userData = await StorageManager.loadUserData();
    if (userData != null && userData['loginToken'] != null) {
      _loginToken = userData['loginToken'];
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userData = await StorageManager.loadUserData();
    _adminId = userData['userId'] ?? 0;
    _loginToken = userData['loginToken'] ?? '';
    _firebaseToken = userData['firebaseToken'] ?? '';
    _adminData['userName'] = userData['userName'] ?? '';
    _adminData['userEmail'] = userData['userEmail'] ?? '';

    notifyListeners();
  }

  Future<void> _saveUserData() async {
    await StorageManager.saveUserData(
      _adminId,
      _loginToken,
      _firebaseToken,
      _adminData['userName']!,
      _adminData['userEmail']!,
    );
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$host/api/admin/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      // Check for a valid response
      if (response.statusCode != 200) {
        print(response.body);
        throw Exception('Failed to login');
      }

      final responseData = json.decode(response.body);
      print(responseData);
      // Ensure responseData is not null
      if (responseData == null) {
        throw Exception('Null response data');
      }

      // Check if the status is 'Failed'
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error'] ?? 'Unknown error');
      }

      _loginToken = responseData['loggintoken'] ?? '';
      print('loginToken:$_loginToken');
      // _firebaseToken = responseData['firebaseToken'] ?? '';
      // print('firebaseToken:$_firebaseToken');
      //dont forget to save the other data like id ,name ,and email
      await StorageManager.updateUserData(loginToken: _loginToken);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> forgetVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/admin/sendOTP');
    print(url);
    print('$code+++++++++++++++++');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'code': code,
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData == null) {
        throw Exception();
      }
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

//enter email for forget password
  Future<void> emailForgetPassword(String email) async {
    final url = Uri.parse('$host/api/companies/sendOTP');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);
      if (responseData == null) {
        throw Exception();
      }
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['data']['Error']);
      }
      print('function done successfolly');
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

//enter new password after email in forget password
  Future<void> newPassword(
      String email, String password, String confirmPassword) async {
    final url = Uri.parse('$host/api/companies/resetPass');
    print(url);
    print(
        'password:$password andddddddddddddddddddd confirmPassword:$confirmPassword');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );
      final responseData = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print(responseData);
      if (responseData == null) {
        throw Exception();
      }
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> passwordRest(
      String oldPassword, String password, String confirmPassword) async {
    final url = Uri.parse('$host/api/companies/changePass');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
        body: {
          'oldPassword': oldPassword,
          'newPassword': password,
          'newPassword_confirmation': confirmPassword,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      print('password updated successfully');
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

  Future<void> emailRest(String newEmail) async {
    final url = Uri.parse('$host/api/companies/changeEmailOTP');
    print(url);
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
        body: {
          'email': newEmail,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Update local user data
      //await StorageManager.updateUserData(userEmail: _email);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error); // Re-throw the error for handling in UI
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$host/api/admin/logout');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      print(" log out successfully$_adminData['email]");
      // Clear tokens and user data from local storage
      await StorageManager.clearUserData();

      // Reset the in-memory variables
      _loginToken = '';
      _firebaseToken = '';
      _adminData['email'] = '';

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error); // Re-throw the error for handling in UI
    }
  }
}
