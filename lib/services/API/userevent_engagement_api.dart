import 'dart:convert';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Models/DTO/NotGetUserEventEngagementDto.dart';
import 'package:mobile_assignment/Models/DTO/UserEventEngagementDto.dart';

class UsereventEngagementApi {
  final baseUrl = "${headUrl}api/userEventEngagement";

  Future<bool> findExistData({
    required int userId,
    required int eventId,
  }) async {
    final uri = Uri.parse(
      '${baseUrl}/exist?userId=${userId}&eventId=${eventId}',
    );
    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return json.decode(response.body);
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<http.Response> updateEventEngagement({
    required int userId,
    required int eventId,
    required Usereventengagementdto userEventEngagement,
  }) async {
    final uri = Uri.parse("${baseUrl}/update/${userId}/${eventId}");

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(userEventEngagement.toJson()),
      );
      return response;
    } catch (e) {
      print('Error: $e');
      // Return a response with error status code
      return http.Response('Error: $e', 500);
    }
  }

  Future<http.Response> createEventEngagement({
    required Usereventengagementdto userEventEngagement,
  }) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(userEventEngagement.toJson()),
      );
      return response;
    } catch (e) {
      print('Error: $e');
      // Return a response with error status code
      return http.Response('Error: $e', 500);
    }
  }

  Future<List<Notgetusereventengagementdto>?> getAllEventEngagement() async {
    final uri = Uri.parse("$baseUrl/all");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((e) => Notgetusereventengagementdto.fromJson(e))
            .toList();
      } else {
        // Log the error or handle non-success status codes
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Log the exception
      print('Exception occurred: $e');
      return null; // or rethrow, or return empty list
    }
  }
}
