// item_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/item_master_stone.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';

class ItemSpecificRepository {
  final Dio _dio;

  ItemSpecificRepository(this._dio);

  Future<Either<Failure, String>> addMetalItem(
      ItemMasterMetal config, String metal) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemMasterAndVariants/Metal/$metal/Item',
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

  Future<Either<Failure, String>> addStoneItem(
      ItemMasterStone config, String stone) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemMasterAndVariants/Stone/$stone/Item',
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

  Future<Either<Failure, String>> addMetalVariant(
      VariantMasterMetal config) async {
    try {
      log(config.toJson().toString());
      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemMasterAndVariants/Metal/Gold/Variant',
        data: config,
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
