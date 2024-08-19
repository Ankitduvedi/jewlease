// item_repository.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class ItemRepository {
  final Dio _dio;

  ItemRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchItemType(String endUrl) async {
    log('$url$endUrl');
    final response = await _dio.get('$url$endUrl');
    return List<Map<String, dynamic>>.from(response.data);
  }
}
