// item_repository.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_type_model.dart';

class ItemRepository {
  final Dio _dio;

  ItemRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchItemType(String endUrl) async {
    log('$url$endUrl');
    if (endUrl.contains("FormulaProcedure") || endUrl.contains('operations')) {
      final response = await _dio.get('$url2$endUrl');
      print("response is2 $url2 $response  ${response.data}");
      return List<Map<String, dynamic>>.from(response.data);
    }
    final response = await _dio.get('$url$endUrl');
    print("response is $response  ${response.data}");
    return List<Map<String, dynamic>>.from(response.data);
  }

  void downloadAsExcel(String endUrl) async {
    log('$url$endUrl');
    await _dio.get('$url$endUrl');
  }

  Future<Either<Failure, String>> submitItemConfiguration(
      ItemConfiguration config) async {
    try {
      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemConfiguration/',
        data: config.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');
        return right(r"Successfully signed out.");
      } else {
        // Error handling
        log('Failed to upload data: ${response.statusCode}');
        return left(Failure(message: response.toString()));
      }
    } catch (e) {
      // Handle errors
      log('Error occurred: $e');
      return left(Failure(message: e.toString()));
    }
  }
}
