import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:http/http.dart' as http;

class Ticketapi {
  final baseUrl = "${headUrl}api/ticket";

  Future<List<Ticketdto>?> GetAllTicket() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url,
        headers: <String, String>{'application/json': 'charset=UTF-8'},
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => Ticketdto.fromJson(e)).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
