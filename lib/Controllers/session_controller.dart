import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placements/Models/sessions.dart';
import 'package:placements/services/api_service.dart';

class SessionController {
  // Get Session Data
  Future<List<Session>> getSessions() async {
    try {
      final url = Uri.parse(ApiService.getSessionDetails);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        // print(data);
        if (data != null) {
          final List<dynamic>? validSessionsData = data['validsession'];
          final List<dynamic>? sessionsData = data['session'];

          if (validSessionsData != null) {
            // Map the validsession list to Sessions objects
            final validSessions = validSessionsData
                .map((json) => Session.fromJson(json))
                .toList();
            return validSessions;
          } else if (sessionsData != null) {
            // Map the session list to Sessions objects
            final sessions =
                sessionsData.map((json) => Session.fromJson(json)).toList();
            return sessions;
          }
        }
      }
      return []; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get sessions: $e');
    }
  }

  // Add New Session Details
  Future<bool> createSession(Session session) async {
    final sessionData = session.toJson();
    sessionData.remove('id'); // Remove the 'id' field from the JSON payload

    final url = Uri.parse(ApiService.addSessionDetails);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        sessionData,
      ), // Pass the modified JSON payload without 'id'
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false; // Failed to create session
    }
  }

  // Update Session Details
  Future<bool> updateSession(Session session) async {
    final url = Uri.parse(
        "${ApiService.addSessionDetails}&id=${Uri.encodeComponent(session.id.toString())}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(session.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Session details updated successfully
    } else {
      return false; // Failed to update session details
    }
  }

  // Delete Session Details
  Future<bool> deleteSession(int id) async {
    final url = Uri.parse("${ApiService.deleteSessionDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Session details deleted successfully
    } else {
      return false; // Failed to delete session details
    }
  }

  Future<bool> updateDefaultBatchStatus(int sessionId) async {
    try {
      final url =
          Uri.parse("${ApiService.updateDefaultBatchStatus}&id=$sessionId");
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to update default batch status: $e');
    }
  }
}
