import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/data/model/failure.dart';

class AuthRepository {
  final Dio _dio = Dio();

  AuthRepository();

  Future<Either<Failure, Employee>> login(
      String username, String password) async {
    try {
      Response response = await _dio.post(
        '$url2/EmployeeMaster/auth',
        data: {'loginName': username, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // Successfully uploaded
        log('login successfully ${response.data}');
        return right(Employee.fromJson(response.data));
      } else {
        // Error handling
        log('Failed to login: ${response.statusCode}');
        return left(Failure(message: response.toString()));
      }
    } catch (e) {
      // Handle errors
      log('Error occurred: $e');
      return left(Failure(message: e.toString()));
    }
  }
}
