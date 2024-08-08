import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.89.229:3000/users";

  Future<void> fetchData() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);
        log('Data fetched: $data');
      } else {
        log('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      log('Error fetching data: $error');
    }
  }
}
