import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/Models/DTO/UserPaymentDto.dart';

class Userapi {
  final String baseUrl = "${headUrl}api/users";

  Future<http.Response> createUser({required Userdto user}) async {
    final uri = Uri.parse("$baseUrl/create");
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(user.toJson()),
      );
      print("Response status: ${response.statusCode}");
      return response;
    } catch (e) {
      // Return a response with error details
      return http.Response(
        json.encode({'error': e.toString()}),
        500,
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Userdto?> getUserByEmail({required String email}) async {
    final uri = Uri.parse("$baseUrl/find/$email");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Userdto.fromJson(data);
      } else {
        print("Failed to fetch user: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<Userdto?> updateUser({required Userdto user}) async {
    final uri = Uri.parse("$baseUrl?email=${user.email}");
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(user.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Userdto.fromJson(data);
      } else {
        print("Failed to update user: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error updating user: $e");
      return null;
    }
  }

  Future<Userdto?> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse("$baseUrl?email=$email&password=$password");
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return Userdto.fromJson(data);
      } else {
        print("Failed to login user: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error logging in user: $e");
      return null;
    }
  }

  Future<void> uploadUserImage({
    required File? image,
    required String imageName,
  }) async {
    final url = Uri.parse("$baseUrl/upload-userimage");
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

  // ignore: non_constant_identifier_names
  Future<UserPaymentdto?> GetUserByUserId({required int id}) async {
    final url = Uri.parse("$baseUrl/id/$id");
    UserPaymentdto? userdata;
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        userdata = UserPaymentdto.fromJson(jsonData);
      }
    } catch (e) {
      print('Error: $e');
    }
    return userdata;
  }
}
