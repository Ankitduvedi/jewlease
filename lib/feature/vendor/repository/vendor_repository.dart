// vendor_repository.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/vendor_model.dart';

class VendorRepository {
  final Dio _dio;

  VendorRepository(this._dio);

  Future<Either<Failure, String>> addVendor(Vendor config) async {
    try {
      final response = await _dio.post(
        'http://13.49.66.204:3000/Master/PartySpecific/vendors/',
        data: config.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Successfully uploaded
        log('Data uploaded successfully');
        return right(r"Successfully Uploaded.");
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
