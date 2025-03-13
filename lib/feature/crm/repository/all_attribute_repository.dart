// item_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/providers/post_request.dart';

class CRMRepository {
  CRMRepository();
  Future<Either<Failure, String>> addCustomer(Customer config) {
    return postRequest(
      endpoint: '$url2/Global/CustomerMaster/',
      data: config.toJson(),
    );
  }
}
