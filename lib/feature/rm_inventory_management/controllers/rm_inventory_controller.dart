import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/rm_inventory_model.dart';
import '../repository/rm_inventory_repository.dart';

class RmInventoryController extends StateNotifier<bool> {
  final RmInventoryRepository _RmInventoryRepository;

  // List to store RmInventory items and current index
  List<RmInventoryItemModel> RmInventoryItems = [];
  int _currentIndex = 0;

  RmInventoryController(this._RmInventoryRepository) : super(false);

  // Fetch all RmInventory items
  Future<void> fetchAllStocks() async {
    try {
      state = true;
      final response = await _RmInventoryRepository.fetchRmInventory();
      RmInventoryItems = response.map((stock) {
        return RmInventoryItemModel.fromJson(stock);
      }).toList();
      state = false;
    } catch (e) {
      print("Error fetching stock: $e");
      RmInventoryItems = [];
      state = false;
    }
  }
  Future<String> sendGRN(Map<String, dynamic> grnData) async {
    // state = const AsyncValue.loading();
    try {
      final response = await _RmInventoryRepository.sendGRN(grnData);

      return response;
      // state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      // state = AsyncValue.error(e, stackTrace);
      return "";
    }
  }

  // Get RmInventory item at a given index
  RmInventoryItemModel getItemAt(int index) {
    return RmInventoryItems[index];

    // Return null if index is invalid
  }

  // Change current index
  void setCurrentIndex(int index) {
    if (index >= 0 && index < RmInventoryItems.length) {
      _currentIndex = index;
    } else {
      print("Invalid index: $index");
    }
  }

  // Get current RmInventory item
  RmInventoryItemModel getCurrentItem() {
    return getItemAt(_currentIndex);
  }
}

final RmInventoryControllerProvider =
    StateNotifierProvider<RmInventoryController, bool>((ref) {
  final dio = Dio();
  final repository = RmInventoryRepository(dio);
  return RmInventoryController(repository);
});

//<---------------------------Hide Graph --------------------------------->

// Create a notifier class to manage the boolean state
class ShowGraphNotifier extends StateNotifier<bool> {
  // Initialize with a default value (e.g., false)
  ShowGraphNotifier() : super(true);

  // Method to toggle the boolean value
  void toggle() {
    state = !state;
  }

  // Method to set a specific value
  void set(bool value) {
    state = value;
  }
}

// Create a provider for the ShowGraphNotifier
final showGraphProvider = StateNotifierProvider<ShowGraphNotifier, bool>((ref) {
  return ShowGraphNotifier();
});
