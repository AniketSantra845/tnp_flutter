import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placements/Models/sector.dart';
import 'package:placements/services/api_service.dart';

class SectorController {
  // Get Sector Data
  Future<List<Sectors>> getSectors() async {
    try {
      final url = Uri.parse(ApiService.getSectorDetails);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        // print(data);
        if (data != null) {
          if (data is List) {
            final sectors = data.map((json) => Sectors.fromJson(json)).toList();
            return sectors;
          } else if (data is Map) {
            final List<dynamic>? sectorsData = data['sectors'];

            if (sectorsData != null) {
              final sectors =
                  sectorsData.map((json) => Sectors.fromJson(json)).toList();
              return sectors;
            }
          }
        }
      }
      return []; // Return an empty list if no data is available
    } catch (e) {
      throw Exception('Failed to get sectors: $e');
    }
  }

  // Add New Sector Details
  Future<bool> createSector(Sectors sector) async {
    final sectorData = sector.toJson();
    sectorData.remove('id'); // Remove the 'id' field from the JSON payload

    final url = Uri.parse(ApiService.addSectorDetails);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        sectorData,
      ), // Pass the modified JSON payload without 'id'
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false; // Failed to create sector
    }
  }

  // Update Sector Details
  Future<bool> updateSector(Sectors sector) async {
    final url = Uri.parse(
        "${ApiService.addSectorDetails}&id=${Uri.encodeComponent(sector.id.toString())}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sector.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Sector details updated successfully
    } else {
      return false; // Failed to update sector details
    }
  }

  // Delete Sector Details
  Future<bool> deleteSector(int id) async {
    final url = Uri.parse("${ApiService.deleteSectorDetails}&id=$id");
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data['success'] == true; // Sector details deleted successfully
    } else {
      return false; // Failed to delete sector details
    }
  }
}
