import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/formula_model.dart';

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

/////////////New Controller

final allVariantFormulasProvider2 =
    StateNotifierProvider<AllFormulaController2, Map<String, FormulaModel>>(
  (ref) => AllFormulaController2(),
);

// AllFormulaController class
class AllFormulaController2 extends StateNotifier<Map<String, FormulaModel>> {
  AllFormulaController2() : super(Map<String, FormulaModel>());

  // Update function to check if key exists, replace value, else add new key-value pair
  void update(String key, FormulaModel formula) {
    state = {
      ...state,
      key: formula,
    };
  }
}
