import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class ProcurementRepository {
  final Dio _dio;

  ProcurementRepository(this._dio);

  Future<String> sendGRN(Map<String, dynamic> data) async {
    print("uploading grn $data");
    print("encoded grn is ${jsonEncode(data)}");

    try {
      final response = await _dio.post(
        "$url2/Procurement/GRN",
        data: jsonEncode(data),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 201) {
        print("stock code is ${response.data}");
        return response.data["stockId"]; // Return response string
      } else {
        throw Exception("Failed to send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending GRN: $e");
      return "";
    }
  }

  Future<void> updateGRN(Map<String, dynamic> data, String stockCode) async {
    data.remove("Stock ID");
    print("update  grn $data");
    print("update grn is ${jsonEncode(data)}");

    try {
      final response = await _dio.put(
        "$url2/Procurement/GRN/$stockCode",
        data: jsonEncode(data),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("update succefully ${response.data}");
        return; // Return response string
      } else {
        throw Exception("Failed to send GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in updating GRN: $e");
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

  Future<List<dynamic>> fetchBom(String bomId) async {
    try {
      final response = await _dio.get(
        "$url2/ItemMasterAndVariants/Style/Style/Variant/$bomId",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("res data ${response.data}");
      final data = response.data;
      print("bom data is $data");
      return data;
    } catch (e) {
      print("error is2 $e");
      return [];
    }
  }
  Future<List<dynamic>> fetchOperation(String oprId) async {
    try {
      final response = await _dio.get(
        "$url2/Operations/$oprId",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("res data ${response.data}");
      final data = response.data;
      print("opr data is $data");
      return data;
    } catch (e) {
      print("error is2 $e");
      return [];
    }
  }
}
