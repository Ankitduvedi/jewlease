import 'package:flutter_riverpod/flutter_riverpod.dart';

// A StateNotifier that manages the List<List<dynamic>>
class DataListNotifier extends StateNotifier<List<List<dynamic>>> {
  DataListNotifier() : super([]);

  // Method to update the list (you can customize this)
  void setData(List<List<dynamic>> newData) {
    state = newData;
  }

  // Method to add a new list inside the main list
  void addData(List<dynamic> newEntry) {
    state = [...state, newEntry];
  }

  // Method to clear the data
  void clearData() {
    state = [];
  }
}

// Provider for the StateNotifier
final dataListProvider =
    StateNotifierProvider<DataListNotifier, List<List<dynamic>>>((ref) {
  return DataListNotifier();
});
