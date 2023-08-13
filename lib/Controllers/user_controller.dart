import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/users.dart';
import '../services/api_service.dart';

class UserController {
  Future<bool> createUser(UserFromUIToDB user) async {
    final userData = user.toJson();
    userData.remove('id'); // Remove the 'id' field from the JSON payload

    final url = Uri.parse(ApiService.addUserDetails);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false; // Failed to create user
    }
  }

  Future<bool> updateUser(UserFromUIToDB user) async {
    final url = Uri.parse(
        "${ApiService.updateUserDetails}&id=${Uri.encodeComponent(user.id.toString())}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // User details updated successfully
    } else {
      return false; // Failed to update user details
    }
  }

  Future<bool> deleteUser(int id) async {
    final url = Uri.parse("${ApiService.deleteUserDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // User details deleted successfully
    } else {
      return false; // Failed to delete user details
    }
  }

  Future<List<Users>> getUsers([int? id]) async {
    try {
      Uri url;
      if (id != null) {
        url = Uri.parse("${ApiService.getUserDetails}&id=${id.toString()}");
      } else {
        url = Uri.parse(ApiService.getUserDetails);
      }
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null) {
          if (data is Map && data["success"] == true) {
            final List<dynamic> usersData =
                id != null ? data["getuser"] : data["StudentUsers"];

            List<Users> users = [];

            if (id != null) {
              users = usersData
                  .map((json) => UserFromUIToDB.fromJson(json))
                  .toList();
            } else {
              users = usersData
                  .map((json) => UsersFromDBToUI.fromJson(json))
                  .toList();
            }
            return users;
          }
        }
      }
      return []; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}
