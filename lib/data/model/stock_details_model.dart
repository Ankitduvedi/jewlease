

class StockDetailsModel {
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

  StockDetailsModel copyWith(
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
      rate: rate ?? this.rate,
      currentStoneWt: currentStoneWt ?? this.currentStoneWt,
      currentNetWt: currentNetWt ?? this.currentNetWt,
    );
  }
}