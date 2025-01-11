// Import Riverpod package
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a notifier class to manage the stat items
class InventoryStatNotifier extends StateNotifier<Map<String, String>> {
  InventoryStatNotifier()
      : super({
          "TotalRows": "0",
          "Pcs": "0",
          "Wt": "0",
          "NetWt": "0",
          "DiaPcs": "0",
          "DiaWt": "0",
          "LgPcs": "0",
          "LgWt": "0",
          "StnPcs": "0",
          "StnWt": "0",
          "MemoInd": "0",
          "SorTransItemId": "0",
          "SorTransItemBomId": "0",
          "OwnerPartyTypeId": "0",
          "ReservePartyId": "0",
          "DiaPcs2": "0",
        });

  // Update an existing stat item
  void updateStatItem(String key, String value) {
    state = {
      ...state,
      key: value,
    };
  }

  // Update multiple stat items
  void updateAll(Map<String, String> newValues) {
    state = {
      ...state,
      ...newValues,
    };
  }
}

// Create a Riverpod provider for the stat notifier
final inventorySummaryProvider =
    StateNotifierProvider<InventoryStatNotifier, Map<String, String>>((ref) {
  return InventoryStatNotifier();
});
