import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class Eventapi {
  final baseUrl = "${headUrl}events";

  Future<List<Eventdto>?> getAllEvents() async {
    final uri = Uri.parse(baseUrl);
    List<Eventdto>? eventdto = [];
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'applicatoin/json;charset=UTF-8',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        eventdto = jsonData.map((e) => Eventdto.fromJson(e)).toList();
      }
    } catch (e) {
      return eventdto;
    }
    return eventdto;
  }
}
