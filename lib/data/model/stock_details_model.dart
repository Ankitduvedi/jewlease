import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

class StockDetailsModel {
  double stockQty;
  double tagCreated;
  double remaining;
  double balPcs;
  double balWt;
  double balMetWt;
  double balStonePcs;
  double balStoneWt;
  double balFindPcs;
  double balFindWt;
  double currentWt = 0.0;
  double rate = 0.0;
  double currentStoneWt = 0.0;
  double currentNetWt = 0.0;
  double currentPieces = 0;
  double currentMetalWt = 0;
  double currentAmount = 0;
  double currentDiaPieces = 0;
  BomModel? currentBom;
  OperationModel? currentOperation;

  StockDetailsModel(
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
      this.currentMetalWt = 0.0,
      this.currentNetWt = 0.0,
      this.currentPieces = 0,
      this.currentAmount = 0,
      this.currentDiaPieces = 0,
      this.currentBom,
      this.currentOperation});

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

  StockDetailsModel copyWith(
      {double? stockQty,
      double? tagCreated,
      double? remaining,
      double? balPcs,
      double? balWt,
      double? balMetWt,
      double? balStonePcs,
      double? balStoneWt,
      double? balFindPcs,
      double? balFindWt,
      double? currentWt,
      double? rate,
      double? currentStoneWt,
      double? currentNetWt,
      double? curentMetalWt,
      double? currentPieces,
      double? currentAmount,
      double? currentDiaPieces,
      BomModel? currentBom,
      OperationModel? currentOpr}) {
    if (currentBom != null) print("old bom is ${currentBom.bomRows[0].amount}");

    return StockDetailsModel(
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
        currentMetalWt: curentMetalWt ?? this.currentMetalWt,
        rate: rate ?? this.rate,
        currentStoneWt: currentStoneWt ?? this.currentStoneWt,
        currentNetWt: currentNetWt ?? this.currentNetWt,
        currentPieces: currentPieces ?? this.currentPieces,
        currentAmount: currentAmount ?? this.currentAmount,
        currentDiaPieces: currentDiaPieces ?? this.currentDiaPieces,
        currentBom: currentBom ?? this.currentBom,
        currentOperation: currentOpr ?? this.currentOperation);
  }
}
