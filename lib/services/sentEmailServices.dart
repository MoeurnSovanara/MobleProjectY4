import 'package:http/http.dart' as http;
import 'package:mobile_assignment/Const/Global/global.dart';

class Sentemailservices {
  final String baseUrl = "${headUrl}sentEmail/";

  Future<http.Response> sendEmail({
    required String email,
    required String subject,
    required String code,
  }) async {
    final uri = Uri.parse("${baseUrl}${email}/${subject}/${code}");
    late http.Response response;
    try {
      response = await http.get(uri);
    } catch (e) {
      return response;
    }
    return response;
  }
}
