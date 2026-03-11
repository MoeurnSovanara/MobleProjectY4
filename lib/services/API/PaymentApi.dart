import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Models/DTO/PaymentDto.dart';

class Paymentapi {
  final baseUrl = "${headUrl}api/Payment";

  Future<http.Response> createPayment({required Paymentdto payment}) async {
    final url = Uri.parse(baseUrl);
    late http.Response respose;
    try {
      respose = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'Application/json;charset=UTF-8',
        },
        body: json.encode(payment.toJson()),
      );
    } catch (e) {
      return respose;
    }
    return respose;
  }

  Future<Paymentdto?> getPayment({required int userId}) async {
    final url = Uri.parse('$baseUrl?userId=$userId');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'content-type': 'application/json;charset=UTF-8;',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        dynamic jsonData = json.decode(response.body);
        return Paymentdto.fromJson(jsonData);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<http.Response> updatePayment({required Paymentdto payment}) async {
    final url = Uri.parse(baseUrl);
    late http.Response response;
    try {
      response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'applicatoin/json;charset=UTF-8;',
        },
        body: json.encode(payment.toJson()),
      );
    } catch (e) {
      return response;
    }
    return response;
  }
}
