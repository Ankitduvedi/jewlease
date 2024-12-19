import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the provider
final procurementVariantProvider = StateNotifierProvider<
    ProcurementVariantNotifier, List<Map<String, dynamic>>>(
  (ref) => ProcurementVariantNotifier(),
);

// StateNotifier to handle the list of maps
class ProcurementVariantNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  ProcurementVariantNotifier() : super([]);

  // Add an item to the list
  void addItem(Map<String, dynamic> item) {
    state = [...state, item];
  }

  // Get an item from the list where the 'variant' key matches the given value
  Map<String, dynamic>? getItemByVariant(String variantValue) {
    return state.firstWhere(
      (item) => item['Varient Name'] == variantValue,
      orElse: () => {},
    );
  }

  // Delete an item from the list where the 'variant' key matches the given value
  void deleteItemByVariant(String variantValue) {
    state =
        state.where((item) => item['Varient Name'] != variantValue).toList();
  }

  // Update the variant based on the 'Varient Name'
  void updateVariant(String variantName, Map<String, dynamic> newValues) {
    state = state.map((item) {
      if (item['Varient Name'] == variantName) {
        // Replace values in item with those from newValues
        Map<dynamic, dynamic> map = {...item, ...newValues};
        print("updated map: $map");
        return {...item, ...newValues}; // Merge new values into existing item
      }
      return item; // Leave other items unchanged
    }).toList();
  }
}
