import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';

final dropDownValueProvider = StateProvider<List<String>>((ref) => ['All']);
final formSequenceProvider = StateProvider<int>((ref) => 0);
final locationProvider = StateProvider<List<Location>>(
    (ref) => [Location(locationName: '', departments: [])]);

class DialogSelectionNotifier extends StateNotifier<Map<String, String?>> {
  DialogSelectionNotifier() : super({'Item Group': null});

  void updateSelection(String key, String value) {
    state = {...state, key: value};
  }

  void clearSelection(String key) {
    state.remove(key);
    state = {...state};
  }
}

final dialogSelectionProvider =
    StateNotifierProvider<DialogSelectionNotifier, Map<String, String?>>(
  (ref) => DialogSelectionNotifier(),
);

class ChechkBoxSelectionNotifier extends StateNotifier<Map<String, bool?>> {
  ChechkBoxSelectionNotifier() : super({'test': false});

  void updateSelection(String key, bool value) {
    state = {...state, key: value};
  }

  void clearSelection(String key) {
    state.remove(key);
    state = {...state};
  }
}

final chechkBoxSelectionProvider =
    StateNotifierProvider<ChechkBoxSelectionNotifier, Map<String, bool?>>(
  (ref) => ChechkBoxSelectionNotifier(),
);

class DropDownSelectionNotifier extends StateNotifier<Map<String, String?>> {
  DropDownSelectionNotifier() : super({'test': null});

  void updateSelection(String key, String value) {
    state = {...state, key: value};
  }

  void clearSelection(String key) {
    state.remove(key);
    state = {...state};
  }
}

final dropDownProvider =
    StateNotifierProvider<DropDownSelectionNotifier, Map<String, String?>>(
  (ref) => DropDownSelectionNotifier(),
);
