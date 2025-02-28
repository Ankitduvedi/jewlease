// item_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/data/model/failure.dart';

class DepartmentsRepository {
  final Dio _dio;

  DepartmentsRepository(this._dio);

  Future<Either<Failure, String>> addDepartments(Departments config) async {
    try {
      log(config.toJson().toString());

      final response = await _dio.post(
        '$url2/Global/Department',
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
