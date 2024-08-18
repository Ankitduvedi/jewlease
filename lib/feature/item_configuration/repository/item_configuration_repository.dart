// item_repository.dart
import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class ItemRepository {
  final Dio _dio;

  ItemRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await _dio.get('${url}ItemConfiguration/ItemType/');
    return List<Map<String, dynamic>>.from(response.data);
  }
}
