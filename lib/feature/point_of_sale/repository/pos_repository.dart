import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/data/model/payment.dart';

import '../../../core/routes/constant.dart';

class POSRepository {
  final Dio _dio;

  POSRepository(this._dio);

  Future<String?> postPayement(Map<String, dynamic> payment) async {
    try {
      final response = await _dio.post(
        "$url2/Pos",
        data: jsonEncode(payment),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("res data ${response.data}");
      final data = response.data;
      print("opr data is $data");
      return data["posId"];
    } catch (e) {
      print("error is2 $e");
    }
  }
  Future<List<dynamic>> fetchPayements(String partyName) async {
    print("partyname $partyName ");
    try {
      final response = await _dio.get(
        "$url2/Pos/PartyName/$partyName",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("res data ${response.data}");
      final data = response.data;
      print("opr data is $data");

      return data["data"];
    } catch (e) {
      print("error is2 $e");
      return [];
    }
  }
}
