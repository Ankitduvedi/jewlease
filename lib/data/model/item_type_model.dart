class ItemConfiguration {
  String itemType;
  String itemGroup;
  String itemNature;
  String stockUOM;
  String dependentCr;
  bool lotManagementIndicator;
  bool customStockReqdInd;
  bool bomIndicator;
  bool operationReqdInd;
  String wastage;
  String metalToleranceDown;
  String metalToleranceUp;
  String alloyToleranceDown;
  String inwardRateTolerance;

  ItemConfiguration({
    required this.itemType,
    required this.itemGroup,
    required this.itemNature,
    required this.stockUOM,
    required this.dependentCr,
    required this.lotManagementIndicator,
    required this.customStockReqdInd,
    required this.bomIndicator,
    required this.operationReqdInd,
    required this.wastage,
    required this.metalToleranceDown,
    required this.metalToleranceUp,
    required this.alloyToleranceDown,
    required this.inwardRateTolerance,
  });

  Map<String, dynamic> toJson() => {
        'ItemType': itemType,
        'ItemGroup': itemGroup,
        'ItemNature': itemNature,
        'StockUOM': stockUOM,
        'DependentCr': dependentCr,
        'LOTManagementIndicator': lotManagementIndicator,
        'CustomStockReqdInd': customStockReqdInd,
        'BOMIndicator': bomIndicator,
        'OperationReqdInd': operationReqdInd,
        'Wastage': wastage,
        'MetalToleranceDown': metalToleranceDown,
        'MetalToleranceUp': metalToleranceUp,
        'AlloyToleranceDown': alloyToleranceDown,
        'InwardRateTolerance': inwardRateTolerance,
      };
}
