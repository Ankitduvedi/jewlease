import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class OutwardRepository {
  final Dio _dio;

  OutwardRepository(this._dio);

  Future<void> sendOutward(
      String stockId, String source, String destination) async {
    Map<String, dynamic> reqBody = {
      "stockId": "$stockId",
      "sourceDepartment": "$source",
      "destinationDepartment": "$destination"
    };
    print("req body $reqBody");
    try {
      final response = await _dio.post(
        "$url2/Transfer/Department",
        data: jsonEncode(reqBody),
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

  Future<Map<String, dynamic>> fetchGRN(String stockCode) async {
    try {
      final response = await _dio.get(
        "$url2/Procurement/GRN/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch inward  succefully ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed inward fetch  GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching inward GRN: $e");
      return {};
      ;
    }
  }

  Future<void> updateGRN(Map<dynamic, dynamic> data, String stockCode) async {
    print("update inward grn $data");
    print("update inward grn is ${jsonEncode(data)}");

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

  Future<String> deleteInward(String stockCode) async {
    print("delete  grn $stockCode");

    try {
      final response = await _dio.delete(
        "$url2/Transfer/Department/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("stock code is ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed to deleted inward GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in delete inward GRN: $e");
      return "";
    }
  }
}

class OutwardLocRepository {
  final Dio _dio;

  OutwardLocRepository(this._dio);

  Future<void> sendOutwardLoc(
      String stockId, String source, String destination) async {
    Map<String, dynamic> reqBody = {
      "stockId": "$stockId",
      "sourceDepartment": "ada",
      "destinationDepartment": "$destination"
    };
    print("req body loc $reqBody");
    // return;
    try {
      final response = await _dio.post(
        "$url2/Transfer/Location",
        data: jsonEncode(reqBody),
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

  Future<Map<String, dynamic>> fetchGRN(String stockCode) async {
    try {
      final response = await _dio.get(
        "$url2/Procurement/GRN/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch inward  succefully ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed inward fetch  GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching inward GRN: $e");
      return {};
      ;
    }
  }

  Future<void> updateGRN(Map<dynamic, dynamic> data, String stockCode) async {
    print("update inward grn $data");
    print("update inward grn is ${jsonEncode(data)}");

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

  Future<String> deleteInward(String stockCode) async {
    print("delete  grn $stockCode");

    try {
      final response = await _dio.delete(
        "$url2/Transfer/Department/$stockCode",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("stock code is ${response.data}");
        return response.data; // Return response string
      } else {
        throw Exception("Failed to deleted inward GRN: ${response.data}");
      }
    } catch (e) {
      print("Error in delete inward GRN: $e");
      return "";
    }
  }
}
