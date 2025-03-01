import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state as a list of maps
class ReturnRawListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ReturnRawListNotifier() : super([]);

  // Function to update a map based on variantName and rowNo
  Map<String, dynamic> findMap(String variantName, int rowNo) {
    return state.firstWhere(
          (map) => map['styleVariant'] == variantName && map['rowNo'] == rowNo,
      orElse: () => {},
    );
  }

  // Function to add a new map to the list
  void addMap(Map<String, dynamic> newMap) {
    state = [...state, newMap];
  }
}

// Define the provider
final returnRawListProvider =
StateNotifierProvider<ReturnRawListNotifier, List<Map<String, dynamic>>>(
      (ref) => ReturnRawListNotifier(),
);
