// lib/services/api_service.dart
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://mortava.biz.id/api';

  Future<http.Response> postRaw(String endpoint, String body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
  }

  Future<http.Response> getRaw(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
  }
}
