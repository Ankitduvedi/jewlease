import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state as a LinkedHashMap
final varientAllFormulaProvider =
    StateNotifierProvider<AllFormulaController, Map<String, dynamic>>(
  (ref) => AllFormulaController(),
);

// AllFormulaController class
class AllFormulaController extends StateNotifier<Map<String, dynamic>> {
  AllFormulaController() : super(Map<String, dynamic>());

  // Update function to check if key exists, replace value, else add new key-value pair
  void update(String key, dynamic value) {
    state = {
      ...state,
      key: value,
    };
  }
}
