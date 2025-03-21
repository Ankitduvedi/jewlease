import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class RmInventoryRepository {
  final Dio _dio;

  RmInventoryRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchRmInventory() async {
    final response = await _dio.get('$url2/Procurement/GRN');
    try {
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load inventory data');
      }
    } catch (e) {
      print("error in stock api $e");
      return [];
    }
  }

  Future<String> sendGRN(Map<String, dynamic> data) async {
    print("uploading rmgrn $data");
    print("encoded rmgrn is ${jsonEncode(data)}");

    try {
      final response = await _dio.post(
        "$url2/Procurement/RawMaterial",
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
        throw Exception("Failed to send rmGRN: ${response.data}");
      }
    } catch (e) {
      print("Error in sending rmGRN: $e");
      return "";
    }
  }
}

// Provider for repository
