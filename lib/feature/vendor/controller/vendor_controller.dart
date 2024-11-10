// Define a provider to manage the state of the selected master type
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/vendor_model.dart';
import 'package:jewlease/feature/vendor/repository/vendor_repository.dart';



// Create a StateNotifier for managing the state and interactions
class VendorController extends StateNotifier<bool> {
  final VendorRepository _vendorRepository;

  VendorController(this._vendorRepository) : super(false);

  Future<void> submitVendorConfiguration(
      Vendor config, BuildContext context) async {
    try {
      state = true;
      final response = await _vendorRepository.addVendor(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Vendor Created', context);
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
final vendorControllerProvider =
    StateNotifierProvider<VendorController, bool>((ref) {
  final dio = Dio();
  final repository = VendorRepository(dio);
  return VendorController(repository);
});
