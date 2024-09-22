// Define a provider to manage the state of the selected master type
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/feature/item_specific/repository/item_configuration_repository.dart';

final masterTypeProvider =
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
class ItemSpecificController extends StateNotifier<bool> {
  final ItemSpecificRepository _itemSpecificRepository;

  ItemSpecificController(this._itemSpecificRepository) : super(false);

  Future<void> submitMetalItemConfiguration(
      ItemMasterMetal config, BuildContext context, String metal) async {
    try {
      log('in controller');

      state = true;
      final response =
          await _itemSpecificRepository.addMetalItem(config, metal);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('error');
      Utils.snackBar(e.toString(), context);
      state = false;
    }
  }

  Future<void> submitMetalVariantConfiguration(
      VariantMasterMetal config, BuildContext context) async {
    try {
      state = true;
      final response = await _itemSpecificRepository.addMetalVariant(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Variant Created', context);
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
    StateNotifierProvider<ItemSpecificController, bool>((ref) {
  final dio = Dio();
  final repository = ItemSpecificRepository(dio);
  return ItemSpecificController(repository);
});
