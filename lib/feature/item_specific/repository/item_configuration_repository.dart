// item_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/feature/item_specific/widgets/right_side_pannel_load_variant_master_gold.dart';

class ItemSpecificRepository {
  final Dio _dio;

  ItemSpecificRepository(this._dio);

  Future<Either<Failure, String>> addMetalItem(ItemMasterMetal config) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemMasterAndVariants/Metal/Gold/Item',
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
      // final co = {
      //   "Metal name": "Ankit",
      //   "Variant type": "Red Gold",
      //   "Base metal Variant": "Gold Pure",
      //   "Std. selling rate": 5500.00,
      //   "Std. buying rate": 5200.00,
      //   "Reorder Qty": 100,
      //   "Used in BOM": "Yes",
      //   "Can Return in Melting": true,
      //   "Row status": "Active",
      //   "Created Date": "2024-01-01",
      //   "Update Date": "2024-01-10",
      //   "Metal Color": "Yellow",
      //   "Karat": "24K"
      // };
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
