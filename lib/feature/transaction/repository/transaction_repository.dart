import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/barcode_historyModel.dart';
import 'package:jewlease/data/model/transaction_model.dart';

class TransactionRepository {
  final Dio _dio;

  TransactionRepository(this._dio);

  Future<String?> sentTransaction(TransactionModel transaction) async {
    // return "";

    try {
      final response = await _dio.post(
        "$url2/Transaction/History",
        data: jsonEncode(transaction.toJson()),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ${response.data} ");
      if (response.statusCode == 201) {
        // pr
        print("successfully transaction send GRN ${response.data}");
        return response.data["transId"];

      } else {
        throw Exception("Failed to transaction send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending transaction GRN: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchTransaction(String transactionID) async {
    try {
      final response = await _dio.get(
        "$url2/Barcode/History/",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch barcode History  succefully ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed barcode History fetch: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching barcode History: $e");
      return [];
      ;
    }
  }

}
