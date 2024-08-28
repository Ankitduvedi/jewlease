// item_repository.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_code_generation_model.dart';

class ItemCodeGenerationRepository {
  final Dio _dio;

  ItemCodeGenerationRepository(this._dio);

  Future<Either<Failure, String>> addItemCodeGeneration(
      ItemCodeGeneration config) async {
    try {
      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemCodeGeneration/',
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
