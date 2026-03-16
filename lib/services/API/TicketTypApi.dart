import 'dart:convert';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/TicketTypeDto.dart';
import 'package:http/http.dart' as http;

class TickettypeApi {
  final baseUrl = "${headUrl}api/TicketType";

  Future<List<TicketTypeDto>?> createTicketType({
    required List<TicketTypeDto> ticketTypes,
  }) async {
    final url = Uri.parse(baseUrl);
    List<TicketTypeDto>? createdTicketTypes;

    try {
      // Convert the list of objects to a list of JSON maps
      final List<Map<String, dynamic>> ticketTypesJson = ticketTypes
          .map((ticketType) => ticketType.toJson())
          .toList();

      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
        },
        body: json.encode(ticketTypesJson),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final List<dynamic> responseData = json.decode(response.body);
        createdTicketTypes = responseData
            .map((jsonData) => TicketTypeDto.fromJson(jsonData))
            .toList();
      } else {
        print(
          'Failed to create ticket types. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return createdTicketTypes;
  }

  Future<http.Response> updateTicketType({
    required int ticketTypeId,
    required int quantity,
  }) async {
    final url = Uri.parse(
      '$baseUrl/quantity?ticketTypeId=$TickettypeApi&quantity=$quantity',
    );
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'content-type': 'application/json;charset=UTF-8',
        },
      );
      return response;
    } catch (e) {
      // Log the error or handle it appropriately
      print('Error updating ticketType: $e');
      // Rethrow the exception to let the caller handle it
      rethrow;
    }
  }
}
