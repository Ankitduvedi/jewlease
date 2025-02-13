import 'package:dio/dio.dart';

class ApiRepository {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
