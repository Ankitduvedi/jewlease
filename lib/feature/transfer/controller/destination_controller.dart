import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the notifier
class DestinationNotifier extends StateNotifier<Map<String, dynamic>> {
  DestinationNotifier() : super({});

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
final destinationProvider =
    StateNotifierProvider<DestinationNotifier, Map<String, dynamic>>((ref) {
  return DestinationNotifier();
});
