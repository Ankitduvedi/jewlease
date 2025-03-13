// item_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/feature/crm/repository/all_attribute_repository.dart';

// Create a StateNotifier for managing the state and interactions
class CRMController extends StateNotifier<bool> {
  final CRMRepository _cRMRepository;

  CRMController(this._cRMRepository) : super(false);

  Future<void> submitCustomerConfiguration(
      Customer config, BuildContext context) async {
    try {
      state = true;
      final response = await _cRMRepository.addCustomer(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Customer Created', context);
        context.pop();
        null;
      });

      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }
}

// Define a provider for the controller
final cRMControllerProvider = StateNotifierProvider<CRMController, bool>((ref) {
  final repository = CRMRepository();
  return CRMController(repository);
});
