import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:http/http.dart' as http;

class UsereventEngagementApi {
  final baseUrl = "${headUrl}userEventEngagement";

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
}
