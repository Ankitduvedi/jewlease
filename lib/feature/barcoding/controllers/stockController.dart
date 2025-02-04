import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/stock_details_model.dart';

class StockDetailsNotifier extends Notifier<StockDetailsModel> {
  @override
  StockDetailsModel build() {
    // Default initialization
    return StockDetailsModel();
  }

  // Initialize the state with a StockDetails model
  void initialize(StockDetailsModel details) {
    state = details;
  }

  // Update the state with values from another StockDetails model
  void update(StockDetailsModel updatedDetails) {
    state = state.copyWith(
      stockQty: updatedDetails.stockQty != 0 ? updatedDetails.stockQty : null,
      tagCreated:
          updatedDetails.tagCreated != 0 ? updatedDetails.tagCreated : null,
      remaining:
          updatedDetails.remaining != 0 ? updatedDetails.remaining : null,
      balPcs: updatedDetails.balPcs != 0 ? updatedDetails.balPcs : null,
      balWt: updatedDetails.balWt != 0.0 ? updatedDetails.balWt : null,
      balMetWt: updatedDetails.balMetWt != 0.0 ? updatedDetails.balMetWt : null,
      balStonePcs:
          updatedDetails.balStonePcs != 0 ? updatedDetails.balStonePcs : null,
      balStoneWt:
          updatedDetails.balStoneWt != 0.0 ? updatedDetails.balStoneWt : null,
      balFindPcs:
          updatedDetails.balFindPcs != 0 ? updatedDetails.balFindPcs : null,
      balFindWt:
          updatedDetails.balFindWt != 0.0 ? updatedDetails.balFindWt : null,
      currentWt:
          updatedDetails.currentWt != 0.0 ? updatedDetails.currentWt : null,
      rate: updatedDetails.rate != 0.0 ? updatedDetails.rate : null,
      currentStoneWt: updatedDetails.currentStoneWt != 0.0
          ? updatedDetails.currentStoneWt
          : null,
      currentNetWt: updatedDetails.currentNetWt != 0.0
          ? updatedDetails.currentNetWt
          : null,
    );
  }
}

// Provider to expose StockDetailsNotifier
final stockDetailsProvider =
    NotifierProvider<StockDetailsNotifier, StockDetailsModel>(
        () => StockDetailsNotifier());
// Provider to expose StockDetailsNotifier

// Model to encapsulate stock details

