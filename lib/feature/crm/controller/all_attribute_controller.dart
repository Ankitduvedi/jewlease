// item_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/feature/crm/repository/all_attribute_repository.dart';

// Create a StateNotifier for managing the state and interactions

final dioProvider = Provider((ref) => Dio());

class CRMController extends StateNotifier<AsyncValue<void>> {
  final CRMRepository _cRMRepository;
  final Ref _ref;

  CRMController(this._cRMRepository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> submitCustomerConfiguration(
      CustomerModel config, BuildContext context) async {
    try {
      state = const AsyncValue.loading();
      final response = await _cRMRepository.addCustomer(config);
      state = const AsyncValue.data(null);
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Customer Created', context);
        context.pop();
        null;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<CustomerModel>> fetchCustomers() async {
    state = const AsyncValue.loading();
    try {
      final response = await _cRMRepository.fetchAllCustomers();
      print("response ${response.length}");
      List<CustomerModel> customers = [];

      response.forEach((element) {
        customers.add(CustomerModel.fromJson(element as Map<String,dynamic>));
      });
      state = const AsyncValue.data(null);
      return customers;
    } catch (e, stackTrace) {
      print("errro in conversion history model $e");
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }
}

final crmRepositoryProvider = Provider(
  (ref) => CRMRepository(ref.read(dioProvider)),
);

// Define a provider for the controller
// final cRMControllerProvider = StateNotifierProvider<CRMController, bool>((ref) {
//   final repository = CRMRepository();
//   return CRMController(repository);
// });

final cRMControllerProvider =
    StateNotifierProvider<CRMController, AsyncValue<void>>((ref) {
  final repository = ref.watch(crmRepositoryProvider);
  return CRMController(repository, ref);
});
