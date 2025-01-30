import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/barcode_historyModel.dart';

class BarcodeHistoryRepository {
  final Dio _dio;

  BarcodeHistoryRepository(this._dio);

  Future<void> sentBarcodeHistory(BarcodeHistoryModel History) async {
    print("history ${History.toJson()}");

    try {
      final response = await _dio.post(
        "$url2/Barcode/History/",
        data: jsonEncode(History.toJson()),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 201) {
        print("successfully outward send GRN ${response.data}");
      } else {
        throw Exception("Failed to outward send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending otward GRN: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllBarcodeHistory() async {
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

  Future<List<Map<String, dynamic>>> fetchBarcodeHistory(
      String stockCode) async {
    try {
      final response = await _dio.get(
        "$url2/Barcode/History/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch barcode History  succefully ${response.data}");
        return (response.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList(); // Return response string
      } else {
        throw Exception("Failed barcode History fetch: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching barcode History: $e");
      return [];
      ;
    }
  }

  Future<String> deleteGRN(String stockCode) async {
    print("delete  grn $stockCode");

    try {
      final response = await _dio.delete(
        "$url2/Procurement/GRN/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("stock code is ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed to send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in delete GRN: $e");
      return "";
    }
  }
}
