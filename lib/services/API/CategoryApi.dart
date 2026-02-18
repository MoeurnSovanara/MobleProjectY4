import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/CategoryDto.dart';
import 'package:http/http.dart' as http;

class Categoryapi {
  final baseUrl = "${headUrl}category";

  Future<List<Categorydto>?> getAllCategory() async {
    final uri = Uri.parse(baseUrl);
    List<Categorydto>? data = [];
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'applicatoin/json,charset=UTF-8',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((e) => Categorydto.fromJson(e)).toList();
      }
    } catch (e) {
      return data;
    }
    return data;
  }
}
