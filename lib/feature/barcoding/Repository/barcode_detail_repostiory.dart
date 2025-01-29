import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/barcode_detail_model.dart';

class BarcodeDetailRepository {
  final Dio _dio;

  BarcodeDetailRepository(this._dio);

  Future<void> sentBarcodeDetail(BarcodeDetailModel details) async {
    print("detail is ${details.toJson()}");

    try {
      final response = await _dio.post(
        "$url2/Barcode/Detail/",
        data: jsonEncode(details.toJson()),
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

  Future<List<Map<String, dynamic>>> fetchAllBarcodeDetail() async {
    try {
      final response = await _dio.get(
        "$url2/Barcode/History/",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch barcode detail  succefully ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed barcode detail fetch: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching barcode detail: $e");
      return [];
      ;
    }
  }

  Future<List<Map<String, dynamic>>> fetchBarcodeDetail(
      String stockCode) async {
    try {
      final response = await _dio.get(
        "$url2/Barcode/Detail/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch barcode detail  succefully ${response.data}");
        return (response.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        ; // Return response string
      } else {
        throw Exception("Failed barcode detail fetch: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching barcode detail: $e");
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
