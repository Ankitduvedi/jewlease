import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the notifier
class ProvVendorNotifier extends StateNotifier<Map<String, dynamic>> {
  ProvVendorNotifier() : super({});

  // Add or update an entry
  void updateEntry(String key, dynamic value) {
    state = {...state, key: value};
  }

  // Remove an entry
  void removeEntry(String key) {
    final updatedMap = Map.of(state);
    updatedMap.remove(key);
    state = updatedMap;
  }

  // Clear the entire map
  void clearMap() {
    state = {};
  }
}

// Create the provider
final pocVendorProvider =
    StateNotifierProvider<ProvVendorNotifier, Map<String, dynamic>>((ref) {
  return ProvVendorNotifier();
});
