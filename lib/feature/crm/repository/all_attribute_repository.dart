// item_repository.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/providers/post_request.dart';

class CRMRepository {
  CRMRepository(this._dio);

  final Dio _dio;

  Future<Either<Failure, String>> addCustomer(CustomerModel config) {
    return postRequest(
      endpoint: '$url2/Global/CustomerMaster/',
      data: config.toJson(),
    );
  }

  Future<List<dynamic>> fetchAllCustomers() async {
    try {
      final response = await _dio.get(
        "$url2/Global/CustomerMaster/",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("status code ${response.statusCode}  ");
      if (response.statusCode == 200) {
        print("fetch barcode detail  succefully ${response.data}");
        // List<dyna
        List<dynamic>data = response.data;
        return  data ; // Return response string
      } else {
        throw Exception("Failed barcode detail fetch: ${response.data}");
      }
    } catch (e) {
      print("Error in fetching barcode detail: $e");
      return [];
      ;
    }
  }
}
