// First map: item -> bool (isSelected)
import 'package:flutter_riverpod/flutter_riverpod.dart';

// First map: item -> isSelected
final selectedItemProvider =
    StateNotifierProvider<SelectedItemNotifier, Map<String, bool>>((ref) {
  return SelectedItemNotifier();
});

class SelectedItemNotifier extends StateNotifier<Map<String, bool>> {
  SelectedItemNotifier() : super({});

  void addItem(String item, bool isSelected) {
    state = {...state, item: isSelected};
  }
}

// Second map: item -> item value
final itemValueProvider =
    StateNotifierProvider<ItemValueNotifier, Map<String, dynamic>>((ref) {
  return ItemValueNotifier();
});

class ItemValueNotifier extends StateNotifier<Map<String, dynamic>> {
  ItemValueNotifier() : super({});

  void addItemValue(String item, dynamic value) {
    state = {...state, item: value};
  }
}

// Function to add items to both maps
final addItemProvider = Provider((ref) {
  void addItem(String item, bool isSelected, dynamic value) {
    ref.read(selectedItemProvider.notifier).addItem(item, isSelected);
    ref.read(itemValueProvider.notifier).addItemValue(item, value);
  }

  return addItem;
});

// Function to fetch both maps
final fetchMapsProvider = Provider((ref) {
  Map<String, Map<String, dynamic>> fetchMaps() {
    final selectedMap = ref.read(selectedItemProvider);
    final valueMap = ref.read(itemValueProvider);

    return {
      'selectedItems': selectedMap,
      'itemValues': valueMap,
    };
  }

  return fetchMaps;
});

/////////////////////////single item provider

class ItemNotifier extends StateNotifier<String> {
  ItemNotifier() : super('');

  // Function to set the item
  void setItem(String item) {
    state = item;
  }

  // Function to get the item
  String getItem() {
    return state;
  }
}

// Provider for the ItemNotifier
final itemProvider = StateNotifierProvider<ItemNotifier, String>((ref) {
  return ItemNotifier();
});

//////value provider
class ValueNotifier extends StateNotifier<String> {
  ValueNotifier() : super('');

  // Function to set the item
  void setValue(String item) {
    state = item;
  }

  // Function to get the item
  String getValue() {
    return state;
  }
}

// Provider for the ItemNotifier
final valueProvider = StateNotifierProvider<ValueNotifier, String>((ref) {
  return ValueNotifier();
});
