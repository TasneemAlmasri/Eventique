import 'dart:convert';
import 'package:eventique/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletProvider with ChangeNotifier {
  final String token;
  final int id;
  WalletProvider(this.token, this.id);
  int _amount = 0;

  int get walletAmount {
    return _amount;
  }

  Future<void> getWalletAmount() async {
    final url = Uri.parse('$host/api/userwallets/$id');
    print(url);
    print(token);
    print(id);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      _amount = responseData['amount'];
      print(_amount);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> AddToWallet(int amount) async {
    final url = Uri.parse('$host/api/wallets');
    print(url);
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'locale': 'en',
        },
        body: {
          "amount": amount.toString(),
          'user_id': id.toString(),
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
      _amount = responseData['data'];
      print(_amount);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
