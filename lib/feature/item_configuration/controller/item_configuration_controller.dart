// item_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_type_model.dart';
import 'package:jewlease/feature/item_configuration/repository/item_configuration_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final dio = Dio(); // You might want to configure Dio further if needed
  return ItemRepository(dio);
});

final itemTypeFutureProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, parameter) async {
  final repository = ref.read(itemRepositoryProvider);
  return await repository.fetchItemType(parameter);
});

// Create a StateNotifier for managing the state and interactions
class ItemConfigurationController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;

  ItemConfigurationController(this._itemRepository) : super(false);

  Future<void> submitItemConfiguration(
      ItemConfiguration config, BuildContext context) async {
    try {
      state = true;
      final response = await _itemRepository.submitItemConfiguration(config);
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
final itemConfigurationControllerProvider =
    StateNotifierProvider<ItemConfigurationController, bool>((ref) {
  final dio = Dio();
  final repository = ItemRepository(dio);
  return ItemConfigurationController(repository);
});
