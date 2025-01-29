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
              transactionNumber: 1231,
              date: DateTime.now().toIso8601String(),
              bom: {},
              operation: {},
              formula: {})
        ]);

  /// Add a new BarcodeHistoryModel to the existing list
  void addBarcodeHistory(BarcodeHistoryModel History) {
    final hasDefault =
        state.isNotEmpty && state.first.stockId == 'xyx'; // Check for default
    if (hasDefault) {
      state = [History, ...state.skip(1)]; // Replace default with new element
    } else {
      state = [...state, History]; // Append to the existing list
    }
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
