import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/data/model/failure.dart';

class EmployeeRepository {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<Either<Failure, String>> addEmployee(Employee config) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        '$url2/EmployeeMaster',
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
