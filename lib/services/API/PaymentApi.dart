import 'dart:convert';

import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Models/DTO/PaymentDto.dart';

class Paymentapi {
  final baseUrl = "${headUrl}api/Payment";

  Future<http.Response> CreatePayment({required Paymentdto payment}) async {
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
}
