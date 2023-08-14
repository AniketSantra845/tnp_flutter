import 'dart:convert';

import 'package:placements/Models/Student_Applications/db_to_ui.dart';
import 'package:placements/Models/Student_Applications/pendinglistdb_to_ui.dart';
import 'package:placements/services/api_service.dart';
import 'package:http/http.dart' as http;

class StudentApplicationController {
  Future getStudentApplication() async {
    try {
      final stdapp_url = Uri.parse(ApiService.getAppliedCompanies);

      final stdapp_response = await http.get(stdapp_url);

      if (stdapp_response.statusCode == 200) {
        final dynamic stdapp_data = jsonDecode(stdapp_response.body);
        if (stdapp_data['success'] == true) {
          if (stdapp_data is List) {
            final data = stdapp_data
                .map((json) => StudentApplicationDbToUi.fromJson(json))
                .toList();
            return data;
          } else if (stdapp_data is Map) {
            final List<dynamic>? dynamicdata = stdapp_data['appliedcompanies'];
            //log(dynamicdata as String);
            if (dynamicdata != null) {
              final data = dynamicdata
                  .map((json) => StudentApplicationDbToUi.fromJson(json))
                  .toList();
              return data;
            }
          }
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get student Applications details: $e');
    }
  }

  Future getPendingShortList(int hiring_id) async {
    try {
      final pendlist_url = Uri.parse(
          "${ApiService.getAppliedStudents}&hid=${Uri.encodeComponent(hiring_id.toString())}");
      final pendlist_response = await http.get(pendlist_url);
      if (pendlist_response.statusCode == 200) {
        final dynamic pendlist_data = jsonDecode(pendlist_response.body);
        if (pendlist_data['success'] == true) {
          if (pendlist_data is List) {
            final data = pendlist_data
                .map((json) => PendingList.fromJson(json))
                .toList();
            return data;
          } else if (pendlist_data is Map) {
            final List<dynamic>? dynamicdata = pendlist_data['appliedstudent'];
            if (dynamicdata != null) {
              final data = dynamicdata
                  .map((json) => PendingList.fromJson(json))
                  .toList();
              return data;
            }
          }
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get student Applications details: $e');
    }
  }
}
