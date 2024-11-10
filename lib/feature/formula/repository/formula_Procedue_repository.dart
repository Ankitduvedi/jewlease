// item_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';

class formulaProcedureRepository {
  final Dio _dio;

  formulaProcedureRepository(this._dio);

  Future<Either<Failure, String>> addVendor(ItemMasterMetal config) async {
    try {
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
      final response = await _dio.post(
        'http://13.239.113.142:3000/ItemMasterAndVariants/Metal/Gold/Variant',
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

  Future<Either<Failure, String>> addRangeMaster(
      Map<String, dynamic> requestBody) async {
    try {
      final response = await _dio.post(
        'http://13.49.66.204:3000/FormulaProcedures/RateStructure/',
        data: jsonEncode(requestBody),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response is $requestBody");

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
      log('Error occurred in rate structure: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<List<Map<String, dynamic>>> fetchRangeMaster(
      String rangeHierarchy, String requestBody) async {
    List<Map<String, dynamic>> temData = [
      {
        "rangeHierarchyName": "Anurag",
        "rangeType": "Type A",
        "dataType": "Field1",
        "depdField": "DepField1"
      },
      {
        "rangeHierarchyName": "Anurag",
        "rangeType": "Type A",
        "dataType": "Field2",
        "depdField": "DepField2"
      },
      {
        "rangeHierarchyName": "Anurag",
        "rangeType": "Type A",
        "dataType": "Field3",
        "depdField": "DepField3"
      }
    ];

    try {
      final response = await _dio.post(
        'http://13.49.66.204:3000/FormulaProcedures/RateStructure/$rangeHierarchy',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response is $requestBody");

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');

        return temData;
      } else {
        // Error handling
        log('Failed to upload data: ${response.statusCode}');
        return temData;
      }
    } catch (e) {
      // Handle errors
      log('Error occurred in rate structure: $e');
      return temData;
    }
  }

  Future<Either<Failure, String>> addRangeMasterExcel(
      Map<String, dynamic> reqBody) async {
    try {
      final response = await _dio.post(
        'http://13.49.66.204:3000/FormulaProcedures/RateStructure/Excel/',
        data: jsonEncode(reqBody),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response is ${response.data}");

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
      log('Error occurred in uploading excel: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<List<List<dynamic>>> fetchRangeMasterExcel(
      String hierarchyName) async {
    List<List<dynamic>> temData = [
      [
        'Row',
        'Description',
        'Data Type',
        'Variable Name',
        'Range Value',
      ],
      [1, 2, 3, 4, 5],
      [6, 7, 7, 8, 9, 10]
    ];

    try {
      // final response = await _dio.post(
      //   'http://13.49.66.204:3000/FormulaProcedures/RateStructure/Excel/',
      //   options: Options(
      //     headers: {'Content-Type': 'application/json'},
      //   ),
      // );
      // print("response is ${response.data}");
      //
      // if (response.statusCode == 201) {
      //   // Successfully uploaded
      //   log('Data uploaded successfully');
      //
      //   return temData;
      // } else {
      //   // Error handling
      //   log('Failed to upload data: ${response.statusCode}');
      //   return temData;
      // }
      return temData;
    } catch (e) {
      // Handle errors
      log('Error occurred in uploading excel: $e');
      return temData;
    }
  }
}
