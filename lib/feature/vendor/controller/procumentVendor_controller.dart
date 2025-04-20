import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/procumentStyleVariant.dart';

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
      (item) => item['Variant Name'] == variantValue,
      orElse: () => {},
    );
  }

  // Delete an item from the list where the 'variant' key matches the given value
  void deleteItemByVariant(String variantValue) {
    state =
        state.where((item) => item['Variant Name'] != variantValue).toList();
  }

  // Update the variant based on the 'Varient Name'
  void updateVariant(String variantName, Map<String, dynamic> newValues) {
    state = state.map((item) {
      if (item['Variant Name'] == variantName && item["varientIndex"]== newValues["varientIndex"]) {
        // Replace values in item with those from newValues
        Map<dynamic, dynamic> map = {...item, ...newValues};
        print("updated map: $map");
        return {...item, ...newValues}; // Merge new values into existing item
      }
      return item; // Leave other items unchanged
    }).toList();
  }

  void resetAllVariants() {
    state = [];
  }
}

final procurementVariantProvider2 = StateNotifierProvider<
    ProcurementVariantNotifier2, List<ProcumentStyleVariant>>(
  (ref) => ProcurementVariantNotifier2(),
);

// StateNotifier to handle the list of maps
class ProcurementVariantNotifier2
    extends StateNotifier<List<ProcumentStyleVariant>> {
  ProcurementVariantNotifier2() : super([]);

  // Add an item to the list
  void addItem(ProcumentStyleVariant item) {
    state = [...state, item];
  }

  // Get an item from the list where the 'variant' key matches the given value
  ProcumentStyleVariant? getItemByVariant(String variantValue) {
    return state.firstWhere(
      (item) => item.variantName == variantValue,
    );
  }

  // Delete an item from the list where the 'variant' key matches the given value
  // void deleteItemByVariant(String variantValue) {
  //   state =
  //       state.where((item) => item['Variant Name'] != variantValue).toList();
  // }

  // Update the variant based on the 'Varient Name'
  void updateVariant(String variantName, Map<String, dynamic> newValues) {
    print("called updated bom pv3");
    state = state.map((item) {
      print("variant name ${item.variantName} index ${item.vairiantIndex} ${newValues["varientIndex"]}");
      if (item.variantName == variantName &&
          item.vairiantIndex == newValues["varientIndex"]) {
        item.updateVariant(newValues);
        print("called updated bom pv2");
      }
      return item; // Leave other items unchanged
    }).toList();
  }

  void resetAllVariants() {
    state = [];
  }
}
