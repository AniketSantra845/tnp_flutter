import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placements/Models/departments.dart';
import 'package:placements/services/api_service.dart';

class DepartmentController {
  // Get Department Data
  Future<List<Departments>> getDepartments() async {
    try {
      final url = Uri.parse(ApiService.getDepartmentDetails);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        // print(data);
        if (data != null) {
          if (data is List) {
            final departments =
                data.map((json) => Departments.fromJson(json)).toList();
            return departments;
          } else if (data is Map) {
            final List<dynamic>? departmentsData = data['departments'];

            if (departmentsData != null) {
              final departments = departmentsData
                  .map((json) => Departments.fromJson(json))
                  .toList();
              return departments;
            }
          }
        }
      }
      return []; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get departments: $e');
    }
  }

  // Add New Department Details
  Future<bool> createDepartment(Departments department) async {
    final departmentData = department.toJson();
    departmentData.remove('id'); // Remove the 'id' field from the JSON payload
    print(departmentData);
    final url = Uri.parse(ApiService.addDepartmentDetails);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        departmentData,
      ), // Pass the modified JSON payload without 'id'
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false; // Failed to create department
    }
  }

  // Update Department Details
  Future<bool> updateDepartment(Departments department) async {
    final url = Uri.parse(
        "${ApiService.addDepartmentDetails}&id=${Uri.encodeComponent(department.id.toString())}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(department.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Department details updated successfully
    } else {
      return false; // Failed to update department details
    }
  }

  // Delete Department Details
  Future<bool> deleteDepartment(int id) async {
    final url = Uri.parse("${ApiService.deleteDepartmentDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Department details deleted successfully
    } else {
      return false; // Failed to delete department details
    }
  }
}
