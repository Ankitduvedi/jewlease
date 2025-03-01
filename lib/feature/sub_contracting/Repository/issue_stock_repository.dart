import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class IssueStockRepository {
  final Dio _dio;

  IssueStockRepository(this._dio);

  Future<void> sentIssueStock(Map<String, dynamic> reqBody  ) async {
    
    print("req body1 $reqBody");
    // return ;
    try {
      final response = await _dio.post(
        "$url2/SubContracting/IssueWork",
        data: jsonEncode(reqBody),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 201) {
        print("successfully issue GRN ${response.data}");
      } else {
        throw Exception("Failed to issue send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending issue GRN: $e");
    }
  }

  Future<void> updateIssueStock(Map<String, dynamic> reqBody, String stockId  ) async {

    print("req body1 $reqBody");
    // return ;
    try {
      final response = await _dio.put(
        "$url2/SubContracting/IssueWork/$stockId",
        data: jsonEncode(reqBody),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 201) {
        print("successfully update issue ${response.data}");
      } else {
        throw Exception("Failed to update issue : ${response.data}");
      }
    } catch (e) {
      print("Error in update issue: $e");
    }
  }
  Future<void> deleteIssueStock(String stockId) async {

    // return ;
    try {
      final response = await _dio.delete(
        "$url2/SubContracting/IssueWork/$stockId",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 201) {
        print("successfully issue GRN ${response.data}");
      } else {
        throw Exception("Failed to issue send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending issue GRN: $e");
    }
  }


}
