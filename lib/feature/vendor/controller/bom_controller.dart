import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the provider with a state notifier to manage the entire Map.
final bomProvider =
    StateNotifierProvider<BOMNotifier, Map<String, dynamic>>((ref) {
  return BOMNotifier();
});

// Create a StateNotifier to handle the Map operations.
class BOMNotifier extends StateNotifier<Map<String, dynamic>> {
  BOMNotifier() : super({});

  // Function to store a new Map.
  void store(Map<String, dynamic> newMap) {
    state = {...newMap};
  }

  // Function to fetch the entire Map.
  Map<String, dynamic> fetch() {
    return state;
  }

  // Function to update the Map with new entries (merging with existing ones).
  void update(Map<String, dynamic> updatedEntries) {
    state = {...state, ...updatedEntries};
  }

  // Function to delete a key from the Map.
  void delete(String key) {
    if (state.containsKey(key)) {
      final newState = {...state}..remove(key);
      state = newState;
    } else {
      throw Exception("Key does not exist!");
    }
  }
}

final OperationProvider =
    StateNotifierProvider<operationNotifier, Map<String, dynamic>>((ref) {
  return operationNotifier();
});

// Create a StateNotifier to handle the Map operations.
class operationNotifier extends StateNotifier<Map<String, dynamic>> {
  operationNotifier() : super({});

  // Function to store a new Map.
  void store(Map<String, dynamic> newMap) {
    state = {...newMap};
  }

  // Function to fetch the entire Map.
  Map<String, dynamic> fetch() {
    return state;
  }

  // Function to update the Map with new entries (merging with existing ones).
  void update(Map<String, dynamic> updatedEntries) {
    state = {...state, ...updatedEntries};
  }

  // Function to delete a key from the Map.
  void delete(String key) {
    if (state.containsKey(key)) {
      final newState = {...state}..remove(key);
      state = newState;
    } else {
      throw Exception("Key does not exist!");
    }
  }
}
