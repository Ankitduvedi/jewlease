import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/barcode_historyModel.dart';

// import '../../../data/model/barcode_History_model.dart';

class BarcodeHistoryListController
    extends StateNotifier<List<BarcodeHistoryModel>> {
  BarcodeHistoryListController()
      : super([
          BarcodeHistoryModel(
              stockId: 'xyx',
              attribute: '',
              varient: 'xyx',
              transactionNumber: "ABC",
              date: DateTime.now().toIso8601String(),
              bom: {},
              operation: {},
              formula: {})
        ]);

  /// Add a new BarcodeHistoryModel to the existing list
  void addBarcodeHistory(BarcodeHistoryModel history,
      {bool isNewStock = false}) {
    if (isNewStock) {
      state = [history]; // Clears old data and adds the new stock
    } else {
      state = [...state, history]; // Adds to existing data
    }
  }

  void setBarcodeHistory(List<BarcodeHistoryModel> newHistory) {
    state = newHistory; // Replaces the entire list with new data
  }

  /// Remove a BarcodeHistoryModel from the list by index
  void removeBarcodeHistory(int index) {
    if (index >= 0 && index < state.length) {
      final updatedList = [...state];
      updatedList.removeAt(index);
      state = updatedList; // Update the state with the new list
    }
  }
}

final barcodeHistoryListProvider = StateNotifierProvider<
    BarcodeHistoryListController, List<BarcodeHistoryModel>>(
  (ref) => BarcodeHistoryListController(),
);
