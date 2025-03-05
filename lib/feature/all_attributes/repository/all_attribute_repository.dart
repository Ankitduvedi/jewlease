// item_repository.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/all_attribute_model.dart';
import 'package:jewlease/data/model/failure.dart';

class AllAttributeRepository {
  final Dio _dio;

  AllAttributeRepository(this._dio);

  Future<Either<Failure, String>> addAttribute(AllAttribute config) async {
    try {
      final response = await _dio.post(
        '$url2/AllAttribute/',
        data: config.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');
        return right(response.statusCode.toString());
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
