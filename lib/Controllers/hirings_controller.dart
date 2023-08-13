import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placements/Models/Company_hirings/hirings.dart';
import 'package:placements/Models/Company_hirings/view_hirings.dart';
import 'package:placements/Models/company.dart';
import 'package:placements/Models/sessions.dart';
import 'package:placements/services/api_service.dart';

class HiringsController {
  Future getHirings() async {
    try {
      final hurl = Uri.parse(ApiService.getHiringsDetails);
      final curl = Uri.parse(ApiService.getCompanyDetails);
      final surl = Uri.parse(ApiService.getSessionDetails);

      final hresponse = await http.get(hurl);
      final cresponse = await http.get(curl);
      final sresponse = await http.get(surl);

      if (hresponse.statusCode == 200 &&
          cresponse.statusCode == 200 &&
          sresponse.statusCode == 200) {
        final dynamic hdata = jsonDecode(hresponse.body);
        final dynamic cdata = jsonDecode(cresponse.body);
        final dynamic sdata = jsonDecode(sresponse.body);

        if (hdata['success'] == true &&
            cdata['success'] == true &&
            sdata['success'] == true) {
          if (hdata is List && cdata is List && sdata is List) {
            var viewhiringdetails = new ViewHirings();
            viewhiringdetails.hiringDetails = hdata
                .map((e) => ViewHirings.fromJson(e))
                .cast<Hirings>()
                .toList();
            viewhiringdetails.companydetails = cdata
                .map((e) => ViewHirings.fromJson(e))
                .cast<Company>()
                .toList();
            viewhiringdetails.sessiondetails = sdata
                .map((e) => ViewHirings.fromJson(e))
                .cast<Session>()
                .toList();
            return viewhiringdetails;
          } else if (hdata is Map && cdata is Map && sdata is Map) {
            List<dynamic> decodedhiring = jsonDecode(hresponse.body)['hirings'];
            List<dynamic> decodedsession =
                jsonDecode(sresponse.body)['session'];
            List<dynamic> decodedcompany =
                jsonDecode(cresponse.body)['companies'];

            List<Hirings>? hiringsList =
                decodedhiring.map((json) => Hirings.fromJson(json)).toList();

            List<Session>? sessionList =
                decodedsession.map((json) => Session.fromJson(json)).toList();

            List<Company>? companyList =
                decodedcompany.map((json) => Company.fromJson(json)).toList();

            ViewHirings vh = ViewHirings(
                hiringDetails: hiringsList,
                sessiondetails: sessionList,
                companydetails: companyList);

            return vh;
          }
        }
      }
      ViewHirings vh = ViewHirings(
          hiringDetails: [], sessiondetails: [], companydetails: []);
      return vh; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get hiring details: $e');
    }
  }

  // Delete Hiring Details
  Future<bool> deleteHiring(int id) async {
    final url = Uri.parse("${ApiService.deleteHiringsDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true; // Hiring details deleted successfully
    } else {
      return false; // Failed to delete company details
    }
  }
}
