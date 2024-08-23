// To parse this JSON data, do
//
//     final itemConfiguration = itemConfigurationFromJson(jsonString);

import 'dart:convert';

ItemConfiguration itemConfigurationFromJson(String str) =>
    ItemConfiguration.fromJson(json.decode(str));

String itemConfigurationToJson(ItemConfiguration data) =>
    json.encode(data.toJson());

class ItemConfiguration {
  String itemType;
  String itemGroup;
  String itemNature;
  String stockUom;
  String dependentCriteria;
  bool bomIndicator;
  bool lotManagementIndicator;
  String otherLossIndicator;
  bool customStockReqdInd;
  double wastagePercentage;
  double inwardRateToleranceUp;
  double inwardRateToleranceDown;
  bool operationReqdInd;
  bool rowCreationInd;
  double metalToleranceDown;
  double alloyToleranceDown;
  double metalToleranceUp;
  double alloyToleranceUp;

  ItemConfiguration({
    required this.itemType,
    required this.itemGroup,
    required this.itemNature,
    required this.stockUom,
    required this.dependentCriteria,
    required this.bomIndicator,
    required this.lotManagementIndicator,
    required this.otherLossIndicator,
    required this.customStockReqdInd,
    required this.wastagePercentage,
    required this.inwardRateToleranceUp,
    required this.inwardRateToleranceDown,
    required this.operationReqdInd,
    required this.rowCreationInd,
    required this.metalToleranceDown,
    required this.alloyToleranceDown,
    required this.metalToleranceUp,
    required this.alloyToleranceUp,
  });

  factory ItemConfiguration.fromJson(Map<String, dynamic> json) =>
      ItemConfiguration(
        itemType: json["ItemType"],
        itemGroup: json["ItemGroup"],
        itemNature: json["ItemNature"],
        stockUom: json["StockUOM"],
        dependentCriteria: json["DependentCriteria"],
        bomIndicator: json["BOMIndicator"],
        lotManagementIndicator: json["LotManagementIndicator"],
        otherLossIndicator: json["OtherLossIndicator"],
        customStockReqdInd: json["CustomStockReqdInd"],
        wastagePercentage: json["WastagePercentage"],
        inwardRateToleranceUp: json["InwardRateToleranceUp"],
        inwardRateToleranceDown: json["InwardRateToleranceDown"],
        operationReqdInd: json["OperationReqdInd"],
        rowCreationInd: json["RowCreationInd"],
        metalToleranceDown: json["MetalToleranceDown"],
        alloyToleranceDown: json["AlloyToleranceDown"],
        metalToleranceUp: json["MetalToleranceUp"],
        alloyToleranceUp: json["AlloyToleranceUp"],
      );

  Map<String, dynamic> toJson() => {
        "ItemType": itemType,
        "ItemGroup": itemGroup,
        "ItemNature": itemNature,
        "StockUOM": stockUom,
        "DependentCriteria": dependentCriteria,
        "BOMIndicator": bomIndicator,
        "LotManagementIndicator": lotManagementIndicator,
        "OtherLossIndicator": otherLossIndicator,
        "CustomStockReqdInd": customStockReqdInd,
        "WastagePercentage": wastagePercentage,
        "InwardRateToleranceUp": inwardRateToleranceUp,
        "InwardRateToleranceDown": inwardRateToleranceDown,
        "OperationReqdInd": operationReqdInd,
        "RowCreationInd": rowCreationInd,
        "MetalToleranceDown": metalToleranceDown,
        "AlloyToleranceDown": alloyToleranceDown,
        "MetalToleranceUp": metalToleranceUp,
        "AlloyToleranceUp": alloyToleranceUp,
      };
}
