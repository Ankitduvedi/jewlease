import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/inventoryItem.dart';
import '../repository/inventoryRepository.dart';

class InventoryController extends StateNotifier<bool> {
  final InventoryRepository _inventoryRepository;

  // List to store inventory items and current index
  List<InventoryItemModel> inventoryItems = [];
  int _currentIndex = 0;

  InventoryController(this._inventoryRepository) : super(false);

  // Fetch all inventory items
  Future<void> fetchAllStocks( {required String locationName, required String deprtmentName}) async {
    try {
      state = true;
      final response = await _inventoryRepository.fetchInventory();
      inventoryItems = response
          .map((stock) {
            return InventoryItemModel.fromJson(stock);
          })
          .toList()
          .where((item) =>
              item.locationName == locationName &&
              item.department == deprtmentName && item.length>=0)
          .toList();
      state = false;
    } catch (e) {
      print("Error fetching stock: $e");
      inventoryItems = [];
      state = false;
    }
  }

  // Get inventory item at a given index
  InventoryItemModel getItemAt(int index) {

    return inventoryItems[index];

    // Return null if index is invalid
  }

  // Change current index
  void setCurrentIndex(int index) {
    if (index >= 0 && index < inventoryItems.length) {
      _currentIndex = index;
    } else {
      print("Invalid index: $index");
    }
  }

  // Get current inventory item
  InventoryItemModel getCurrentItem() {
    return getItemAt(_currentIndex);
  }
}

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, bool>((ref) {
  final dio = Dio();
  final repository = InventoryRepository(dio);
  return InventoryController(repository);
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
