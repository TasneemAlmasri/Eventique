//taghreed
// ignore_for_file: avoid_print, unnecessary_string_interpolations, use_rethrow_when_possible, prefer_const_constructors, non_constant_identifier_names, unnecessary_nullable_for_final_variable_declarations, prefer_final_fields, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '/main.dart';
import '/shared_preferences/storage_manager.dart';

class Auth with ChangeNotifier {
  bool _isAuthenticated = false;
  String _signUpToken = '';
  String _loginToken = '';
  String _firebaseToken = '';
  int _userId = 0;
  var _userData = {
    'userName': '',
    'userEmail': '',
    'userImage': '',
  };

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

  Auth() {
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
    return 4;
  }

  String get fireToken {
    if (_firebaseToken.isNotEmpty) {
      return _firebaseToken;
    }
    return '';
  }

  Map<String, String> get userData {
    return {..._userData};
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userData = await StorageManager.loadUserData();
    _userId = userData['userId'] ?? 0;
    _signUpToken = userData['signUpToken'] ?? '';
    _loginToken = userData['loginToken'] ?? '';
    _firebaseToken = userData['firebaseToken'] ?? '';
    _userData['userName'] = userData['userName'] ?? '';
    _userData['userEmail'] = userData['userEmail'] ?? '';
    _userData['userImage'] = userData['userImage'] ?? '';
    notifyListeners();
  }

  Future<void> _saveUserData() async {
    await StorageManager.saveUserData(
      _userId,
      _signUpToken,
      _loginToken,
      _firebaseToken,
      _userData['userName']!,
      _userData['userEmail']!,
      _userData['userImage']!,
    );
  }

  Future<void> signUp(
    String imageUrl,
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse('$host/api/register');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'image': imageUrl,
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
      //this is important will be send again to backend in verification code
      _userData['userImage'] = responseData['image'];
      print(_userData['userImage']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; //to handle it in ui
    }
  }

  Future<void> signUpVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/verRegistereOTP');
    print(url);
    print('$email');
    print('$code+++++++++++++++++');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          "image": _userData['userImage'],
          "email": email,
          "code": code,
        },
      );

      // Log the status code and response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      if (response.body.isEmpty) {
        throw FormatException('Empty response body');
      }

      final responseData = json.decode(response.body);
      print("This is the response: $responseData");

      if (responseData == null) {
        throw Exception('Response data is null');
      }

      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      _signUpToken = responseData['rigistertoken'];
      print('signUpToken:$_signUpToken');
      _loginToken = responseData['logginToken'];
      print('loginToken:$_loginToken');
      // _firebaseToken = responseData['firebaseToken'];
      print('firebaseToken:$_firebaseToken');
      _userId = responseData['data']['id'];
      print('userId:$_userId');
      _userData['userName'] = responseData['data']['name'];
      print('userName:${_userData['userName']}');
      _userData['userEmail'] = responseData['data']['email'];
      print('userEmail:${_userData['userEmail']}');
      _userData['userImage'] = responseData['data']['images'][0]['url'];
      print('userImage:${_userData['userImage']}');
      await _saveUserData();
      // await authenticateUserWithCustomToken(_firebaseToken);
      notifyListeners();
    } catch (error) {
      print("Error occurred: ${error.toString()}");
      throw (error);
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$host/api/login');
    print(url);
    print(_signUpToken);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_signUpToken',
        },
        body: {
          'email': email,
          'password': password,
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
      _loginToken = responseData['loginToken'];
      print('loginToken:$_loginToken');
       _firebaseToken = responseData['firebaseToken'];
      print('firebaseToken:$_firebaseToken');
      _userId = responseData['data']['id'];
      print('userId:$_userId');
      _userData['userName'] = responseData['data']['name'];
      print('userName:${_userData['userName']}');
      _userData['userEmail'] = responseData['data']['email'];
      print('userEmail:${_userData['userEmail']}');
      _userData['userImage'] = responseData['data']['images'][0]['url'];
      print('userImage:${_userData['userImage']}');
      await StorageManager.updateUserData(
          firebaseToken: _firebaseToken, loginToken: _loginToken);
      //  await authenticateUserWithCustomToken(_firebaseToken);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  // Future<void> authenticateUserWithCustomToken(String customToken) async {
  //   try {
  //     final FirebaseAuth _auth = FirebaseAuth.instance;
  //     final UserCredential userCredential =
  //         await _auth.signInWithCustomToken(customToken);
  //     User? user = userCredential.user;
  //     if (user != null) {
  //       print('User authenticated successfully with Custom Token');
  //     } else {
  //       print('Failed to authenticate user');
  //     }
  //   } catch (e) {
  //     print('Error during authentication: ${e.toString()}');
  //   }
  // }

  Future<void> forgetVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/verAuthOTP');
    print(url);
    print('$code+++++++++++++++++');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_signUpToken',
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

  Future<void> RestVerificationCode(String email, String code) async {
    final url = Uri.parse('$host/api/verAuthOTP');
    print(url);
    print('$code+++++++++++++++++');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_signUpToken',
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

  Future<void> emailForgetPassword(String email) async {
    final url = Uri.parse('$host/api/sendOTP');
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

  Future<void> newPassword(
      String email, String password, String confirmPassword) async {
    final url = Uri.parse('$host/api/resetPass');
    print(url);
    print(
        'password:$password andddddddddddddddddddd confirmPassword:$confirmPassword');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_signUpToken',
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

  Future<void> updateUserImage(String newImageUrl) async {
    final url = Uri.parse('$host/api/resetImage');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
        body: {
          'image': newImageUrl,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Update local user data
      _userData['userImage'] = newImageUrl;
      print(_userData['userImage']);
      await StorageManager.updateUserData(userImage: _userData['userImage']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

  Future<void> updateUserName(String newName) async {
    final url = Uri.parse('$host/api/resetName');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
        body: {
          'name': newName,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Update local user data
      _userData['userName'] = newName;
      print(_userData['userName']);
      await StorageManager.updateUserData(userName: _userData['userName']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

  Future<void> passwordRest(
      String oldPassword, String password, String confirmPassword) async {
    final url = Uri.parse('$host/api/changePass');
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
    final url = Uri.parse('$host/api/changeEmailOTP');
    print(url);
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
      _userData['userEmail'] = newEmail;
      print(_userData['userEmail']);
      await StorageManager.updateUserData(userEmail: _userData['userEmail']);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }

//this may need edit
  Future<void> sendUserToBackend(User user, String provider) async {
    final url = Uri.parse('$host/api/register-social-user');
    try {
      final idToken = await user.getIdToken();

      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'provider': provider,
          'provider_id': user.uid,
          'token': idToken,
          'profile_picture': user.photoURL ?? '',
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw Exception(responseData['error']);
      }

      // Handle response data as needed
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw ('Google sign-in was canceled.');
        // The user canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        // Authentication failed
        throw ('Google authentication failed.');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Extract user information
      final User? user = userCredential.user;
      if (user != null) {
        final String username = user.displayName ?? '';
        final String email = user.email ?? '';
        final String imageUrl = user.photoURL ?? '';

        // Store user information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use user.uid as the document ID
            .set({
          'username': username,
          'email': email,
          'image_url': imageUrl,
        });
        _userData['userName'] = username;
        _userData['userEmail'] = email;
        _userData['userImage'] = imageUrl;
        print(_userData['userName']);
        print(_userData['userEmail']);
        print(_userData['userImage']);
        // Show success message and navigate
        notifyListeners();
      }
      // Once signed in, return the UserCredential
      return userCredential;
    } catch (error) {
      print("$error--------------------------");
      throw (error);
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$host/api/logout');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_loginToken',
        },
        body: {
          'email': _userData['userEmail'],
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      print(" log out successfully${_userData['userEmail']}");
      // Clear tokens and user data from local storage
      await StorageManager.clearUserData();

      // Reset the in-memory variables
      _loginToken = '';
      _firebaseToken = '';
      _userId = 0;
      _userData['userName'] = '';
      _userData['userEmail'] = '';
      _userData['userImage'] = '';
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error; // Re-throw the error for handling in UI
    }
  }
}
