// item_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/item_master_stone.dart';
import 'package:jewlease/data/model/style_item_model.dart';
import 'package:jewlease/data/model/style_variant_model.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/data/model/variant_master_stone.dart';

class ItemSpecificRepository {
  final Dio _dio;

  ItemSpecificRepository(this._dio);

  Future<Either<Failure, String>> addMetalItem(
      ItemMasterMetal config, String metal) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Metal/$metal/Item',
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

  Future<Either<Failure, String>> addStoneItem(
      ItemMasterStone config, String stone) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Stone/$stone/Item',
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

  Future<Either<Failure, String>> addStoneVariant(
      VariantMasterStone config, String stone) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Stone/$stone/Varient',
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

  Future<Either<Failure, String>> addMetalVariant(
      VariantMasterMetal config, String metal) async {
    try {
      log(config.toJson().toString());
      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Metal/$metal/Variant',
        data: config,
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

  Future<Either<Failure, String>> addStyleItem(ItemMasterStyle config) async {
    try {
      log(config.toJson().toString());
      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Style/Style/Item',
        data: config,
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

  Future<Either<Failure, String>> addStyleVariant(
      ItemMasterVariant config) async {
    try {
      log(config.toJson().toString());
      final response = await _dio.post(
        '$url2/ItemMasterAndVariants/Style/Style/Varient',
        data: config,
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
