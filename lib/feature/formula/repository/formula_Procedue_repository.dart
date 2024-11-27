// item_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/failure.dart';

class formulaProcedureRepository {
  final Dio _dio;

  formulaProcedureRepository(this._dio);

  Future<Either<Failure, String>> addRangeMaster(
      Map<String, dynamic> requestBody) async {
    try {
      final response = await _dio.post(
        url2 + 'FormulaProcedures/RateStructure/',
        data: jsonEncode(requestBody),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response addRangeMaster is $requestBody");

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');
        return right("Successfully signed out.");
      } else {
        // Error handling
        print('Failed to upload data: ${response.statusCode}');
        return left(Failure(message: response.toString()));
      }
    } catch (e) {
      // Handle errors
      print('Error occurred in rate structure: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<List<Map<String, dynamic>>> fetchRangeMasterDepdField(
      String rangeHierarchy, String requestBody) async {
    try {
      final response = await _dio.post(
        url2 +
            'FormulaProcedures/RateStructure/FormulaRangeHierarchy$rangeHierarchy',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response fethcRangeMaster is $requestBody");

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');

        return response.data;
      } else {
        // Error handling
        log('Failed to upload data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle errors
      log('Error occurred in rate structure: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchRangeDialog(
      String rangeHierarchy, String requestBody) async {
    try {
      final response = await _dio.post(
        url2 + 'FormulaProcedures/RateStructure/FormulaRangeMaster',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response fethcRangeMaster is $requestBody");

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');

        return response.data;
      } else {
        // Error handling
        log('Failed to upload data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle errors
      log('Error occurred in rate structure: $e');
      return [];
    }
  }

  Future<Either<Failure, String>> addRangeMasterExcel(
      Map<String, dynamic> reqBody) async {
    try {
      final response = await _dio.post(
        url2 + 'FormulaProcedures/RateStructure/Excel/',
        data: jsonEncode(reqBody),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response is rangeMasterExcel ${response.data}");

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');
        return right(r"Successfully signed out.");
      } else {
        // Error handling
        print('Failed to upload data1: ${response.statusCode}');
        return left(Failure(message: response.toString()));
      }
    } catch (e) {
      // Handle errors
      print('Error occurred in uploading excel1: $e');
      return left(Failure(message: e.toString()));
    }
  }

  Future<Map<dynamic, dynamic>> fetchRangeMasterExcel(
      String hierarchyName) async {
    try {
      final response = await _dio.get(
        url2 + 'FormulaProcedures/RateStructure/Excel/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print(
          "response is fetchRangeMasterExcel${response.statusCode} ${response.data}  ");

      if (response.statusCode == 200) {
        // Successfully uploaded
        log('Data uploaded successfully');
        print("length is ${response.data.length}");

        return response.data[0];
      } else {
        // Error handling
        log('Failed to upload data: ${response.statusCode}');
        return {};
      }
      return {};
    } catch (e) {
      // Handle errors
      log('Error occurred in uploading excel: $e');
      return {};
    }
  }

  Future<Either<Failure, String>> addFormulaExcel(
      Map<String, dynamic> reqBody) async {
    try {
      final response = await _dio.post(
        url2 + 'FormulaProcedures/FormulaProcedureMasterDetails',
        data: jsonEncode(reqBody),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("response formulaExcel is ${response.data}");

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

  Future<Map<String, dynamic>> fetchFormulaExcel() async {
    final response = await _dio
        .get(url2 + 'FormulaProcedures/FormulaProcedureMasterDetails');
    // print("response is $response  ${response.data}");
    List<dynamic> data = response.data;
    print("response formula Excel $data");

    return data[9];
  }
}
