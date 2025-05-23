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
import 'package:jewlease/providers/post_request.dart';

class ItemSpecificRepository {
  ItemSpecificRepository();
  final Dio _dio = Dio();
  Future<Either<Failure, String>> addMetalItem(
      ItemMasterMetal config, String metal) {
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Metal/$metal/Item',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, String>> addStoneItem(
      ItemMasterStone config, String stone) {
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Stone/$stone/Item',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, String>> addStoneVariant(
      VariantMasterStone config, String stone) {
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Stone/$stone/Variant',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, String>> addMetalVariant(
      VariantMasterMetal config, String metal) {
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Metal/$metal/Variant',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, String>> addStyleItem(ItemMasterStyle config) {
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Style/Style/Item',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, String>> addStyleVariant(ItemMasterVariant config) {


    ///
    return postRequest(
      endpoint: '$url2/ItemMasterAndVariants/Style/Style/Variant',
      data: config.toJson(),
    );
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchData(
      String endUrl) async {
    try {
      final response = await _dio.get(
        '$url2/$endUrl',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        log('Data fetched successfully');
        return right(List<Map<String, dynamic>>.from(response.data));
      } else {
        log('Failed to fetch data: ${response.statusCode}');
        return left(Failure(message: 'Failed to fetch data'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Dio error occurred with status code: ${e.response!.statusCode}');
        log('Error data: ${e.response!.data}');
        return left(Failure(message: e.response!.data.toString()));
      } else {
        log('Dio error without response: ${e.message}');
        return left(Failure(message: e.message ?? 'Unknown error'));
      }
    } catch (e) {
      log('Unexpected error occurred: $e');
      return left(Failure(message: e.toString()));
    }
  }
}