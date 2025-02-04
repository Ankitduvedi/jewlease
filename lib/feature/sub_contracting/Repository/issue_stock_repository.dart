import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class IssueStockRepository {
  final Dio _dio;

  IssueStockRepository(this._dio);

  Future<void> sentIssueStock(String stockId, String vendor, String operation,
      String issueDate) async {
    Map<String, dynamic>reqBody = {
      "stockId": "$stockId",
      "vendor": "$vendor",
      "issueDate": "$issueDate",
      "operation": "$operation"
    };
    print("req body $reqBody");
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


}
