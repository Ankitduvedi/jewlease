// Define a provider to manage the state of the selected master type
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/feature/vendor/repository/vendor_repository.dart';

final vendorProvider =
    StateProvider<List<String?>>((ref) => ['Style', null, null]);
// Define a provider for the checkbox state
final checkboxProvider = StateProvider<bool>((ref) => false);

final selectedMetalDataProvider = StateProvider<ItemMasterMetal>((ref) =>
    ItemMasterMetal(
        metalCode: 'test',
        exclusiveIndicator: false,
        description: '',
        rowStatus: '',
        createdDate: DateTime.now(),
        updateDate: DateTime.now(),
        attributeType: '',
        attributeValue: ''));

// Create a StateNotifier for managing the state and interactions
class VendorController extends StateNotifier<bool> {
  final vendorRepository _vendorRepository;

  VendorController(this._vendorRepository) : super(false);

  Future<void> submitMetalItemConfiguration(
      ItemMasterMetal config, BuildContext context) async {
    try {
      state = true;
      final response = await _vendorRepository.addVendor(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }

  Future<void> submitMetalVariantConfiguration(
      VariantMasterMetal config, BuildContext context) async {
    try {
      state = true;
      final response = await _vendorRepository.addMetalVariant(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Item Created', context);
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
final itemSpecificControllerProvider =
    StateNotifierProvider<VendorController, bool>((ref) {
  final dio = Dio();
  final repository = vendorRepository(dio);
  return VendorController(repository);
});
