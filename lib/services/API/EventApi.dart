import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/CreateEventDto.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class Eventapi {
  final baseUrl = "${headUrl}api/event";

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

  Future<void> uploadEventImage({
    required File? image,
    required String imageName,
  }) async {
    final url = Uri.parse("$baseUrl/upload-eventimage");
    if (image != null) {
      try {
        var request = http.MultipartRequest('POST', url);
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: imageName,
          ),
        );

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          print('Upload Successfully!');
        } else {
          print('Upload Failed: ${response.statusCode}');
          print('Response: $responseBody');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<Createeventdto?> CreateEvent({required Createeventdto event}) async {
    final url = Uri.parse('$baseUrl/create');
    Createeventdto? data;
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "Application/json;Charset=UTF-8",
        },
        body: json.encode(event.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        data = Createeventdto.fromJson(jsonData);
      }
    } catch (e) {
      return data;
    }
    return data;
  }

  Future<http.Response> updateEvent({required Createeventdto event}) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'Application/json;Charset=UTF-8',
        },
        body: json.encode(event.toJson()),
      );
      return response;
    } catch (e) {
      // Log the error or handle it appropriately
      print('Error updating event: $e');
      // Rethrow the exception to let the caller handle it
      rethrow;
    }
  }
}
