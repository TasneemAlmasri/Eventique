import 'dart:convert';
import 'package:eventique_company_app/shared_preferences/storage_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthVendor with ChangeNotifier {
  bool _isAuthenticated = false;
  String _loginToken = '';
  String _firebaseToken = '';
  int _userId = 0;
  Map<String, dynamic> _userData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
    'phone': '',
    'companyName': '',
    'registrationNumber': '',
    'location': '',
    'city': '',
    'country': '',
    'description': '',
    'acceptPrivacy': true,
    'image': '',
    'coverImage': '',
    'servicesId': [],
    'eventTypeId': [],
    'days': ['Sunday'],
    'openningHours': {},
    'closingHours': {},
  };
  bool get isAuthenticated => _isAuthenticated;

  Future<void> loadUserData() async {
    final userData = await StorageManager.loadUserData();
    if (userData != null &&
        userData['loginToken'] != null &&
        userData['loginToken'] != '') {
      _loginToken = userData['loginToken'];
      print('Loaded login token:$_loginToken');
      // _userId = userData['userId'];
      // print('Loaded vendorId:$_userId');
      // _firebaseToken = userData['firebaseToken'];
      // _userData['companyName'] = userData['userName'];
      // _userData['email'] = userData['userEmail'];
      // _userData['image'] = userData['userImage'];
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  AuthVendor() {
    _loadUserData();
  }

  String get token {
    if (_loginToken.isNotEmpty) {
      return _loginToken;
    }
    return '';
  }

  int get userId {
    if (_userId != 0) {
      return _userId;
    }
    return -1;
  }

  Map<String, dynamic> get userData {
    return {..._userData};
  }

  String get fireToken {
    if (_firebaseToken.isNotEmpty) {
      return _firebaseToken;
    }
    return '';
  }

//to update each collected data from the screens
  void updateVendorData(Map<String, dynamic> newData) {
    _userData.addAll(newData);
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userData = await StorageManager.loadUserData();
    _userId = userData['userId'] ?? 0;
    _loginToken = userData['loginToken'] ?? '';
    _firebaseToken = userData['firebaseToken'] ?? '';
    _userData['companyName'] = userData['userName'] ?? '';
    _userData['email'] = userData['userEmail'] ?? '';
    _userData['image'] = userData['userImage'] ?? '';
    notifyListeners();
  }

  Future<void> _saveUserData() async {
    await StorageManager.saveUserData(
      _userId,
      _loginToken,
      _firebaseToken,
      _userData['companyName']!,
      _userData['email']!,
      _userData['image']!,
    );
  }

  Future<void> signUp() async {
    final url = Uri.parse('$host/api/insertcompany');
    // final List<Map<String, dynamic>> _workingHours = foramtedHours.map((item) {
    //   return {'day': '', 'hours_from': '', 'hours_to': ''};
    // }).toList();
    final requestBody = {
      "first_name": _userData['firstName'] ?? '',
      "last_name": _userData['lastName'] ?? '',
      "email": _userData['email'] ?? '',
      "password": _userData['password'] ?? '',
      "password_confirmation": _userData['confirmPassword'] ?? '',
      "phone_number": _userData['phone'] ?? '',
      "company_name": _userData['companyName'] ?? '',
      "registration_number": _userData['registrationNumber'] ?? '',
      "location": _userData['location'] ?? '',
      "city": _userData['city'] ?? '',
      "country": _userData['country'] ?? '',
      "description": _userData['description'] ?? '',
      "accept_privacy": _userData['acceptPrivacy'] == true ? 1 : 0,
      "image": _userData['image'] ?? '',
      "category_id": _userData['servicesId'] ?? [],
      "event_type_id": _userData['eventTypeId'] ?? [],
      "work_hours": _formatWorkHours(
        _userData['days'] ?? [],
        _userData['openningHours'] ?? {},
        _userData['closingHours'] ?? {},
      ),
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'locale': 'en',
        },
        body: json.encode(requestBody),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData == null || responseData['Status'] == 'Failed') {
        throw Exception(responseData?['Error'] ?? 'An error occured ');
      }
      _firebaseToken = responseData['firebaseToken'];
      print('firebaseToken:$_firebaseToken');
      _userId = responseData['data']['id'];
      print('userId:$_userId');
      _userData['companyName'] = responseData['data']['company_name'];
      print('userName:${_userData['companyName']}');
      _userData['email'] = responseData['data']['email'];
      print('userEmail:${_userData['email']}');
      _userData['image'] = responseData['data']['images'][0]['url'];
      print('userImage:${_userData['image']}');
      await StorageManager.saveUserData(
        userId,
        _loginToken,
        _firebaseToken,
        _userData['companyName'],
        _userData['email'],
        _userData['image'],
      );
      await authenticateUserWithCustomToken(_firebaseToken);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$host/api/companies/login');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'locale': 'en',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);
      // Check for a valid response
      if (response.statusCode != 200) {
        print(responseData);
        throw Exception('Failed to login');
      }

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
      _firebaseToken = responseData['firebaseToken'] ?? '';
      print('firebaseToken:$_firebaseToken');
      _userId = responseData['data']['id'] ?? 0;
      print('userId:$_userId');
      _userData['companyName'] = responseData['data']['company_name'] ?? '';
      print('companyName:${_userData['companyName']}');
      _userData['email'] = responseData['data']['email'] ?? '';
      print('userEmail:${_userData['email']}');
      _userData['image'] = responseData['data']['images'] != null &&
              responseData['data']['images'].isNotEmpty
          ? responseData['data']['images'][0]['url'] ?? ''
          : '';
      print('userImage:${_userData['image']}');
      _userData['email'] = responseData['data']['email'];
      print('email:${_userData['email']}');
      _userData['phone'] = responseData['data']['phone_number'].toString();
      print(_userData['phone']);
      _userData['description'] = responseData['data']['description'];
      print(_userData['description']);
      _userData['location'] = responseData['data']['location'];
      print(_userData['location']);
      _userData['city'] = responseData['data']['city'];
      print(_userData['city']);
      _userData['country'] = responseData['data']['country'];
      print(_userData['country']);
      await StorageManager.updateUserData(
        firebaseToken: _firebaseToken,
        loginToken: _loginToken,
        userId: _userId,
        userName: _userData['companyName'],
        userEmail: _userData['email'],
        userImage: _userData['image'],
      );
      // await authenticateUserWithCustomToken(_firebaseToken);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> authenticateUserWithCustomToken(String customToken) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.signInWithCustomToken(customToken);
      User? user = userCredential.user;
      if (user != null) {
        print('User authenticated successfully with Custom Token');
      } else {
        print('Failed to authenticate user');
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

//after entering an email send a verification code to this email
  Future<void> forgetVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/companies/verAuthOTP');
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
      throw (error);
    }
  }

//enter email for forget password
  Future<void> emailForgetPassword(String email) async {
    final url = Uri.parse('$host/api/companies/sendOTP');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
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
      throw (error);
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

  Future<void> RestVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/companies/verEmail');
    print(url);
    print(email);
    print('$code+++++++++++++++++');
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
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
    }
  }

//update company logo image
  // Future<void> updateLogoImage(String newImageUrl) async {
  //   final url = Uri.parse('$host/api/resetImage');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $_loginToken',
  //       },
  //       body: {
  //         'image': newImageUrl,
  //       },
  //     );

  //     final responseData = json.decode(response.body);

  //     if (responseData['Status'] == 'Failed') {
  //       throw Exception(responseData['Error']);
  //     }

  //     // Update local user data
  //     _userData['image'] = newImageUrl;
  //     print(_userData['image']);
  //     await StorageManager.updateUserData(userImage: _userData['image']);
  //     notifyListeners();
  //   } catch (error) {
  //     print(error.toString());
  //     throw error; // Re-throw the error for handling in UI
  //   }
  // }

//update company name,or location or .....
  Future<void> updateInfo(String dataName, String newData) async {
    final url = Uri.parse('$host/api/companies/update');
    print(dataName);
    print(newData);
    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
          'locale': 'en'
        },
        body: {
          dataName: newData,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Update local user data
      // _userData['companyName'] = newData;
      // print(_userData['companyName']);
      //await StorageManager.updateUserData(userName: _userData['companyName']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
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
      _userData['email'] = newEmail;
      print(_userData['email']);
      await StorageManager.updateUserData(userEmail: _userData['email']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$host/api/companies/logout');
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

      print(" log out successfully${_userData['email']}");
      // Clear tokens and user data from local storage
      await StorageManager.clearUserData();

      // Reset the in-memory variables
      _loginToken = '';
      _firebaseToken = '';
      _userId = 0;
      _userData['companyName'] = '';
      _userData['email'] = '';
      _userData['image'] = '';
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

  List<Map<String, String>> _formatWorkHours(
    List<int> selectedDays,
    Map<int, TimeOfDay?> openingTimes,
    Map<int, TimeOfDay?> closingTimes,
  ) {
    final List<Map<String, String>> workHours = [];
    final Map<int, String> weekdays = {
      1: 'Sunday',
      2: 'Monday',
      3: 'Tuesday',
      4: 'Wednesday',
      5: 'Thursday',
      6: 'Friday',
      7: 'Saturday',
    };

    for (var day in selectedDays) {
      if (openingTimes.containsKey(day) && closingTimes.containsKey(day)) {
        workHours.add({
          'day': weekdays[day]!,
          'hours_from': _formatTime(openingTimes[day]!),
          'hours_to': _formatTime(closingTimes[day]!),
        });
      }
    }

    return workHours;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
