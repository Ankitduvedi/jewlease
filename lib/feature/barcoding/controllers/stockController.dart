import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockDetailsNotifier extends Notifier<StockDetails> {
  @override
  StockDetails build() {
    // Default initialization
    return StockDetails();
  }

  // Initialize the state with a StockDetails model
  void initialize(StockDetails details) {
    state = details;
  }

  // Update the state with values from another StockDetails model
  void update(StockDetails updatedDetails) {
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
    NotifierProvider<StockDetailsNotifier, StockDetails>(
        () => StockDetailsNotifier());
// Provider to expose StockDetailsNotifier

// Model to encapsulate stock details
class StockDetails {
  int stockQty;
  int tagCreated;
  int remaining;
  int balPcs;
  double balWt;
  double balMetWt;
  int balStonePcs;
  double balStoneWt;
  int balFindPcs;
  double balFindWt;
  double currentWt = 0.0;
  double rate = 0.0;
  double currentStoneWt = 0.0;
  double currentNetWt = 0.0;

  StockDetails(
      {this.stockQty = 0,
      this.tagCreated = 0,
      this.remaining = 0,
      this.balPcs = 0,
      this.balWt = 0.0,
      this.balMetWt = 0.0,
      this.balStonePcs = 0,
      this.balStoneWt = 0.0,
      this.balFindPcs = 0,
      this.balFindWt = 0.0,
      this.currentWt = 0.0,
      this.rate = 0.0,
      this.currentStoneWt = 0.0,
      this.currentNetWt = 0.0});

  // Update values from a map
  void updateFromMap(Map<String, dynamic> map) {
    stockQty = map['stockQty'] ?? stockQty;
    tagCreated = map['tagCreated'] ?? tagCreated;
    remaining = map['remaining'] ?? remaining;
    balPcs = map['balPcs'] ?? balPcs;
    balWt = map['balWt'] ?? balWt;
    balMetWt = map['balMetWt'] ?? balMetWt;
    balStonePcs = map['balStonePcs'] ?? balStonePcs;
    balStoneWt = map['balStoneWt'] ?? balStoneWt;
    balFindPcs = map['balFindPcs'] ?? balFindPcs;
    balFindWt = map['balFindWt'] ?? balFindWt;
  }

  StockDetails copyWith(
      {int? stockQty,
      int? tagCreated,
      int? remaining,
      int? balPcs,
      double? balWt,
      double? balMetWt,
      int? balStonePcs,
      double? balStoneWt,
      int? balFindPcs,
      double? balFindWt,
      double? currentWt,
      double? rate,
      double? currentStoneWt,
      double? currentNetWt}) {
    return StockDetails(
      stockQty: stockQty ?? this.stockQty,
      tagCreated: tagCreated ?? this.tagCreated,
      remaining: remaining ?? this.remaining,
      balPcs: balPcs ?? this.balPcs,
      balWt: balWt ?? this.balWt,
      balMetWt: balMetWt ?? this.balMetWt,
      balStonePcs: balStonePcs ?? this.balStonePcs,
      balStoneWt: balStoneWt ?? this.balStoneWt,
      balFindPcs: balFindPcs ?? this.balFindPcs,
      balFindWt: balFindWt ?? this.balFindWt,
      currentWt: currentWt ?? this.currentWt,
      rate: rate ?? this.rate,
      currentStoneWt: currentStoneWt ?? this.currentStoneWt,
      currentNetWt: currentNetWt ?? this.currentNetWt,
    );
  }
}
