import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class InventoryRepository {
  final Dio _dio;

  InventoryRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchInventory() async {
    final response = await _dio.get('$url2/Procurement/GRN');
    try {
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load inventory data');
      }
    } catch (e) {
      print("error in stock api $e");
      return [];
    }
  }
}

// Provider for repository
