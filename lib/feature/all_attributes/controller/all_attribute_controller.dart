// item_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/all_attribute_model.dart';
import 'package:jewlease/feature/all_attributes/repository/all_attribute_repository.dart';

// Create a StateNotifier for managing the state and interactions
class AllAttributeController extends StateNotifier<bool> {
  final AllAttributeRepository _allAttributeRepository;

  AllAttributeController(this._allAttributeRepository) : super(false);

  Future<void> submitAttributeConfiguration(
      AllAttribute config, BuildContext context) async {
    try {
      state = true;
      final response = await _allAttributeRepository.addAttribute(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Attribute Value Created', context);
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
final allAttributeControllerProvider =
    StateNotifierProvider<AllAttributeController, bool>((ref) {
  final dio = Dio();
  final repository = AllAttributeRepository(dio);
  return AllAttributeController(repository);
});
