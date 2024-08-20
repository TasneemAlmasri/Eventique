import 'dart:convert';
import 'package:eventique/main.dart';
import 'package:eventique/models/vendor_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class VendorsProvider with ChangeNotifier {
  String token;
  VendorsProvider(this.token);

  List<Vendor> _vendors = [];
  List<Vendor> get vendorsList {
    return [..._vendors];
  }

  Vendor findById(String id) {
    return _vendors.firstWhere((vendor) => vendor.id == id);
  }

  Future<void> fetchAllVendors() async {
    const url = '$host/api/companies/allCompanies';
    print(url);
    print(token);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'locale': 'en',
      });
      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final data =
            responseData['data'] as List<dynamic>; // Cast to List<dynamic>

        // Map the response data to a List<Vendor>
        _vendors = data.map<Vendor>((vendorData) {
          // Map work hours if available
          List<WorkHour> workHours = [];
          if (vendorData['workHours'] != null) {
            workHours = (vendorData['workHours'] as List<dynamic>)
                .map<WorkHour>((workHourData) {
              return WorkHour(
                day: workHourData['day'],
                hoursFrom: workHourData['hours_from'],
                hoursTo: workHourData['hours_to'],
              );
            }).toList();
          }

          // Return a Vendor object
          return Vendor(
            id: vendorData['id'].toString(),
            firstName: vendorData['first_name'],
            lastName: vendorData['last_name'],
            email: vendorData['email'],
            phoneNumber: vendorData['phone_number'].toString(),
            companyName: vendorData['company_name'],
            location: vendorData['location'],
            city: vendorData['city'],
            country: vendorData['country'],
            description: vendorData['description'],
            imageUrl:
                vendorData['images'] != null && vendorData['images'].isNotEmpty
                    ? vendorData['images'][0]['url'] ?? ''
                    : '', // Set the image URL
            workHours: workHours, // Set the work hours list
          );
        }).toList(); // Cast to List<Vendor>

        notifyListeners();
      } else {
        throw Exception('Failed to load vendors');
      }
    } catch (error) {
      print('Error fetching vendors: $error');
      throw error;
    }
  }
}
