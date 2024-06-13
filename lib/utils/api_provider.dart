import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';

class ApiProvider {
  static Future postRequest({required String endPoint, Object? body}) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(AppStrings.baseUrl + endPoint), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception(AppStrings.somethingWentWrongStr);
    } catch (e) {
      return e.toString();
    }
  }

  static Future getRequest({required String endPoint}) async {
    try {
      final response = await http.get(Uri.parse(AppStrings.baseUrl + endPoint));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception(AppStrings.somethingWentWrongStr);
    } catch (e) {
      return e.toString();
    }
  }
}
