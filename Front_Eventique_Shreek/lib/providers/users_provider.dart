import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventique_company_app/main.dart';
import 'package:eventique_company_app/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UsersProvider with ChangeNotifier {
  String token;
  UsersProvider(this.token);
  List<OneUser> _users = [];

  List<OneUser> get users => _users;
  Future<void> fetchUsersForVendor(String vendorId) async {
    const url = '$host/api/allUsers';
    print(url);
    print(token);

    try {
      // Send the GET request to the API
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        // Authorization header was removed, add it back if needed
      });

      // Parse the response
      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData;

        List<OneUser> loadedUsers = [];

        for (var userJson in data) {
          loadedUsers.add(OneUser(
            id: userJson['id'],
            name: userJson['name'] ??
                'Unknown', // Provide a default value if null
            imageUrl:
                userJson['images'] != null && userJson['images'].isNotEmpty
                    ? userJson['images'][0]['url'] ?? ''
                    : '',
            email: userJson['email'] ?? '',
          ));
        }

        _users = loadedUsers;
        print('print users:$_users');
        notifyListeners();

        print('Total users fetched: ${_users.length}');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error fetching users: $error');
      throw error;
    }
  }
  // // Method to fetch users who have sent messages to this vendor
  // Future<void> fetchUsersForVendor(String vendorId) async {
  //   try {
  //     print('Fetching chats for vendor: $vendorId');

  //     // Fetch chat documents where the vendor is the recipient
  //     final chatSnapshots = await FirebaseFirestore.instance
  //         .collection('chats')
  //         .where('recieverId', isEqualTo: vendorId)
  //         .get();

  //     if (chatSnapshots.docs.isEmpty) {
  //       print('No chats found for this vendor.');
  //       return; // Early exit if no chats are found
  //     }

  //     print('Found ${chatSnapshots.docs.length} chat documents.');

  //     // Extract user IDs from chat documents
  //     Set<String> userIds = {};
  //     for (var chatDoc in chatSnapshots.docs) {
  //       print('Processing chat document: ${chatDoc.id}');
  //       var chatId =
  //           chatDoc.id.split('_'); // Assuming chatId is userId_vendorId
  //       var userId = chatId.first == vendorId ? chatId.last : chatId.first;
  //       print('Extracted userId: $userId');
  //       userIds.add(userId);
  //     }

  //     // If no user IDs are found, exit early
  //     if (userIds.isEmpty) {
  //       print('No userIds found in chats.');
  //       return;
  //     }

  //     print('Fetching user data for userIds: $userIds');

  //     // Fetch user information based on userIds
  //     List<OneUser> loadedUsers = [];
  //     for (var userId in userIds) {
  //       print('Fetching user data for userId: $userId');
  //       final userSnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .get();

  //       if (userSnapshot.exists) {
  //         print('User data found for $userId: ${userSnapshot.data()}');
  //         loadedUsers.add(OneUser(
  //           id: int.parse(userSnapshot.id),
  //           name: userSnapshot.data()!['userName'],
  //           imageUrl: userSnapshot.data()!['userImage'],
  //         ));
  //       } else {
  //         print('No user data found for $userId');
  //       }
  //     }

  //     // Update the provider's list of users and notify listeners
  //     _users = loadedUsers;
  //     notifyListeners();

  //     print('Total users fetched: ${_users.length}');
  //   } catch (error) {
  //     print('Error fetching users: $error');
  //     throw error;
  //   }
  // }

  OneUser findById(int id) {
    return _users.firstWhere((user) => user.id == id);
  }
}
