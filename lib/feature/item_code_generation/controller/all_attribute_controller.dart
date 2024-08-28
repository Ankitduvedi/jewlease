// item_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_code_generation_model.dart';
import 'package:jewlease/feature/item_code_generation/repository/item_configuration_repository.dart';

// Create a StateNotifier for managing the state and interactions
class ItemCodeGEnerationController extends StateNotifier<bool> {
  final ItemCodeGenerationRepository _allAttributeRepository;

  ItemCodeGEnerationController(this._allAttributeRepository) : super(false);

  Future<void> submitItemCodeGenerationConfiguration(
      ItemCodeGeneration config, BuildContext context) async {
    try {
      state = true;
      final response =
          await _allAttributeRepository.addItemCodeGeneration(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Item Configuration Created', context);
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
final itemCodeGenerationProvider =
    StateNotifierProvider<ItemCodeGEnerationController, bool>((ref) {
  final dio = Dio();
  final repository = ItemCodeGenerationRepository(dio);
  return ItemCodeGEnerationController(repository);
});
