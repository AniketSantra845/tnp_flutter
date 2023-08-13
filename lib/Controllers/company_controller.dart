import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Models/company.dart';
import '../services/api_service.dart';

class CompanyController {
  // Get Company Data
  Future<List<Company>> getCompanies() async {
    try {
      final url = Uri.parse(ApiService.getCompanyDetails);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null) {
          if (data is List) {
            final companies =
                data.map((json) => Company.fromJson(json)).toList();
            return companies;
          } else if (data is Map) {
            final List<dynamic>? companiesData = data['companies'];

            if (companiesData != null) {
              final companies =
                  companiesData.map((json) => Company.fromJson(json)).toList();
              return companies;
            }
          }
        }
      }
      return []; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get companies: $e');
    }
  }

  // Add New Company Details
  Future<bool> createCompany(Company company) async {
    final companyData = company.toJson();
    companyData.remove('id'); // Remove the 'id' field from the JSON payload

    final url = Uri.parse(ApiService.addCompanyDetails);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        companyData,
      ), // Pass the modified JSON payload without 'id'
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false; // Failed to create company
    }
  }

  // Update Company Details
  Future<bool> updateCompany(Company company) async {
    final url = Uri.parse(
        "${ApiService.addCompanyDetails}&id=${Uri.encodeComponent(company.id.toString())}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(company.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Company details updated successfully
    } else {
      return false; // Failed to update company details
    }
  }

  // Delete Company Details
  Future<bool> deleteCompany(int id) async {
    final url = Uri.parse("${ApiService.deleteCompanyDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Company details deleted successfully
    } else {
      return false; // Failed to delete company details
    }
  }
}
