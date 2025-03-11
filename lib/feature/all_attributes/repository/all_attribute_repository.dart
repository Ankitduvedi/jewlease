// item_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/all_attribute_model.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/providers/post_request.dart';

class AllAttributeRepository {
  AllAttributeRepository();
  Future<Either<Failure, String>> addAttribute(AllAttribute config) {
    return postRequest(
      endpoint: '$url2/AllAttribute/',
      data: config.toJson(),
    );
  }
}
