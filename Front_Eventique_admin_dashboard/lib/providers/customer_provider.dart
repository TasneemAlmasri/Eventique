import 'dart:convert';
import 'dart:developer';
import 'package:eventique_admin_dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eventique_admin_dashboard/models/customer/customer.dart';
import 'package:eventique_admin_dashboard/models/user/user.dart';

class CustomerProvider with ChangeNotifier {
  CustomerProvider(this.token);
  String token;
  List<User> _users = [];
  List<Company> _companies = [];

  List<User> get users => _users;
  List<Company> get companies => _companies;

  Future<void> fetchUsers(String token) async {
    print('iam in fetchUsers and token is $token');
    final endPoint = '$host/api/admin/allUsers';
    try {
      final response = await http.get(
        Uri.parse(endPoint),
        headers: {
          'Accept': 'application/json',
          'locale': 'en',
          'Authorization': 'Bearer $token',
        },
      );
      print('iam after get');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('iam in 200');
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          _users = jsonData
              .map<User>((json) => User(
                    id: json['id'],
                    name: json['name'],
                    email: json['email'],
                    images: List<String>.from(
                        json['images']?.map((image) => image['url']) ?? []),
                  ))
              .toList();
        } else {
          print('Unexpected data format: ${jsonData.runtimeType}');
        }
      } else {
        print('Error: Received non-200 status code');
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }

  Future<void> fetchCompanies(String token) async {
    print('iam in fetchCompanies');
    final endPoint = "/api/admin/allCompanies";
    try {
      final response = await http.get(
        Uri.parse("$host$endPoint"),
        headers: {
          'Accept': 'application/json',
          'locale': 'en',
          'Authorization': 'Bearer $token',
        },
      );
      print('i am after get');

      if (response.statusCode == 200) {
        print('iam in 200');
        print('Response Body: ${response.body}');
        final jsonData = json.decode(response.body);

        // Check if jsonData is a Map and contains a 'data' key
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          final List<dynamic> companiesData = jsonData['data'];
          _companies = companiesData
              .map<Company>((json) => Company(
                    id: json['id'],
                    firstName: json['first_name'],
                    lastName: json['last_name'],
                    phoneNumber: json['phone_number'],
                    images: List<String>.from(
                        json['images']?.map((image) => image['url']) ?? []),
                    city: json['city'],
                    companyName: json['company_name'],
                    country: json['country'],
                    email: json['email'],
                    loaction: json['location'],
                  ))
              .toList();
        } else {
          print('Unexpected data format: ${jsonData.runtimeType}');
        }
      } else {
        print('Error: Received non-200 status code');
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }

  Future<void> deleteCompany(int companyId) async {
  print('I am in deleteCompany');
  final url = Uri.parse('$host/api/admin/deleteCompany/$companyId');
  print(url);

  try {
    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Set content type to JSON
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Delete company 200');
      // Remove the deleted company from the local list
      _companies.removeWhere((company) => company.id == companyId);
      notifyListeners(); // Notify listeners to update the UI
    } else {
      throw Exception('Failed to delete company');
    }
  } catch (error) {
    print(error);
    throw error;
  }
}

}
