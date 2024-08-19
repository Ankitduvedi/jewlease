import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';

final dropDownValueProvider = StateProvider<List<String>>((ref) => ['All']);

class DialogSelectionNotifier extends StateNotifier<Map<String, String?>> {
  DialogSelectionNotifier() : super({'Item Group': null});

  void updateSelection(String key, String value) {
    state = {...state, key: value};
  }

  void clearSelection() {
    state = {'Item Group': null};
  }
}

final dialogSelectionProvider =
    StateNotifierProvider<DialogSelectionNotifier, Map<String, String?>>(
  (ref) => DialogSelectionNotifier(),
);

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedColumnProvider = StateProvider<String>((ref) => 'All');
final filteredItemsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

final filteredItemsFutureProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedColumn = ref.watch(selectedColumnProvider);
  final items = await ref.watch(itemTypeFutureProvider.future);

  return items.where((item) {
    if (searchQuery.isEmpty) {
      return true;
    }
    if (selectedColumn == 'All') {
      return item.values.any((value) =>
          value != null &&
          value.toString().toLowerCase().contains(searchQuery));
    } else {
      return item[selectedColumn]
              ?.toString()
              .toLowerCase()
              .contains(searchQuery) ??
          false;
    }
  }).toList();
});
