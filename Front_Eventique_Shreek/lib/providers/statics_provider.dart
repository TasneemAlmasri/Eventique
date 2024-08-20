import 'dart:convert';

import 'package:eventique_company_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatisticsProvider with ChangeNotifier {
  final String token;
  final int id;
  StatisticsProvider(this.token, this.id);
  int _amount = 100000000;
  var _statistics = {
    'customers': '',
    'services': '',
    'rating': '',
    'revenue': ''
  };

  Map<String, String> get statistics {
    return {..._statistics};
  }

  Future<void> getStatistics(String route, String date) async {
    final url = Uri.parse('$host/api/company/statistics/$route');
    print(url);
    print(date);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'date': date,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      _statistics['customers'] = responseData['user_count'].toString();
      _statistics['services'] = responseData['service_count'].toString();
      _statistics['revenue'] = responseData['total_profit'].toString();
      _statistics['rating'] = responseData['avg_rating'] == null
          ? 'No rating'
          : responseData['avg_rating'].toString();
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  int get walletAmount {
    return _amount;
  }

  Future<void> getWalletAmount() async {
    final url = Uri.parse('$host/api/companies/companyWallet');
    print(url);
    print(token);
    print(id);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      _amount = responseData['amount'];
      print(_amount);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
