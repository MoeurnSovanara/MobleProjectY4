import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/VenuesNameDto.dart';
import 'package:http/http.dart' as http;

class Venuesapi {
  final baseUrl = "${headUrl}api/Venue";

  Future<Venuesnamedto?> CreateVenues({required Venuesnamedto venue}) async {
    final url = Uri.parse(baseUrl);
    Venuesnamedto? data;
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'Application/json;charset=UTF-8',
        },
        body: json.encode(venue.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        data = Venuesnamedto.fromJson(jsonData);
      }
    } catch (e) {
      return data;
    }
    return data;
  }

  Future<http.Response> updateVeneus({required Venuesnamedto venue}) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: json.encode(venue.toJson()),
      );
      return response;
    } catch (e) {
      print('Error update venues: $e');
      rethrow;
    }
  }
}
