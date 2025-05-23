import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../data/model/inventoryItem.dart';
import '../../../data/model/procumentStyleVariant.dart';
import '../repository/inventoryRepository.dart';

class InventoryController extends StateNotifier<bool> {
  final InventoryRepository _inventoryRepository;

  // List to store inventory items and current index
  List<ProcumentStyleVariant> inventoryItems = [];
  int _currentIndex = 0;

  InventoryController(this._inventoryRepository) : super(false);

  // Fetch all inventory items
  Future<void> fetchAllStocks(
      {required String locationName,
      required String deprtmentName,
      required bool isRawMaterial}) async {
    // try {
      state = true;
      inventoryItems=[];
      final response = await _inventoryRepository.fetchInventory();
      print("inventory reponse is $response");
      // inventoryItems =
      for (int i = 0; i < response.length; i++) {
        ProcumentStyleVariant basicVariant =
            ProcumentStyleVariant.fromJson(response[i], i);
        print("bom id1 ${basicVariant.stockID} ${basicVariant.bomId}");
        ProcumentStyleVariant completeVariant =
            await ProcumentStyleVariant.initializeCalculatedFields(
                basicVariant, basicVariant.vairiantIndex);
        inventoryItems.add(completeVariant);
      }
      // .where((item) =>
      //     item.locationName == locationName &&
      //     item.department == deprtmentName &&
      //     item.length >= 0 &&
      //     item.isRawMaterial == (isRawMaterial == true?1:0))
      // .toList();
      print("inventory items are ${inventoryItems.length}");
      state = false;
    // }
    // catch (e) {
    //   print("Error fetching stock: $e");
    //   inventoryItems = [];
    //   state = false;
    // }
  }

  // Get inventory item at a given index
  ProcumentStyleVariant getItemAt(int index) {
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
  ProcumentStyleVariant getCurrentItem() {
    return getItemAt(_currentIndex);
  }
  updateStyleVariant(ProcumentStyleVariant newStyleVariant) {

    inventoryItems[newStyleVariant.vairiantIndex] = newStyleVariant;
    print("updated bom ${inventoryItems[newStyleVariant.vairiantIndex].bomData.bomRows[1].weight}");
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
