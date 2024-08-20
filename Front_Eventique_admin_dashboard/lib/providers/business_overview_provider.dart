import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:eventique_admin_dashboard/main.dart';
import 'package:eventique_admin_dashboard/models/revenue_model.dart';
import 'package:eventique_admin_dashboard/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusinessOverviewPro with ChangeNotifier {
  final String token;
  BusinessOverviewPro(this.token);
  var _statistics = {
    'customers': '',
    'companies': '',
    'revenue': '',
    'events': ''
  };
  List<Vendor> _companyRequests = [];

  List<Vendor> get getCompaniesRequests {
    print(_companyRequests);
    return [..._companyRequests];
  }

  Map<String, String> get statistics {
    return {..._statistics};
  }

  Future<void> getTotalStatistics() async {
    final url = Uri.parse('$host/api/admin/totalStatistics');
    print(url);
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
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      _statistics['customers'] = responseData['user_count'].toString();
      _statistics['companies'] = responseData['company_count'].toString();
      _statistics['revenue'] = responseData['total_profit'].toString();
      _statistics['events'] = responseData['events'].toString();
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getStatistics(String route, String date) async {
    final url = Uri.parse('$host/api/admin/$route');
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
      _statistics['companies'] = responseData['company_count'].toString();
      _statistics['revenue'] = responseData['total_profit'].toString();
      _statistics['events'] = responseData['events'].toString();
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> companiesRequests() async {
    final url = Uri.parse('$host/api/admin/applications');
    print(url);

    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'locale': 'en',
      });

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Parse and map the response data to the Vendor model
      List<Vendor> loadedVendors = [];
      for (var vendorData in responseData['data']) {
        List<Map<String, String>> workHours = [];
        for (var hours in vendorData['workHours']) {
          workHours.add({
            'day': hours['day'],
            'hours_from': hours['hours_from'],
            'hours_to': hours['hours_to'],
          });
        }

        Vendor vendor = Vendor(
          id: vendorData['id'],
          logoUrl: vendorData['images'].isNotEmpty
              ? vendorData['images'][0]['url']
              : '',
          companyName: vendorData['company_name'],
          email: vendorData['email'],
          phoneNumber: vendorData['phone_number'].toString(),
          firstName: vendorData['first_name'],
          lastName: vendorData['last_name'],
          registrationNumber: vendorData['registration_number'].toString(),
          location: vendorData['location'],
          city: vendorData['city'],
          country: vendorData['country'],
          description: vendorData['description'],
          categoryIds: [], // Update this if you have categories in your response
          eventTypeIds: [], // Update this if you have event types in your response
          workHours: workHours,
        );

        loadedVendors.add(vendor);
      }

      _companyRequests = loadedVendors;
      print('companies fetched:$_companyRequests');
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<Map<String, int>> dataForYear(String year) async {
    final url = Uri.parse('$host/api/admin/profitParagraph');
    print(url);

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'date': year,
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }

      // Convert responseData to Map<String, int>
      Map<String, int> monthlyRevenue = {};
      for (var key in responseData.keys) {
        monthlyRevenue[key] = int.tryParse(responseData[key].toString()) ?? 0;
      }

      notifyListeners();
      return monthlyRevenue;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  //update company rejection or acception
  Future<void> updateCompanyStatus(int id, bool status) async {
    final url = Uri.parse('$host/api/admin/acceptCompany');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'companyId': id.toString(),
          'status': status ? '1' : '0',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['Status'] == 'Failed') {
        throw Exception(responseData['Error']);
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
