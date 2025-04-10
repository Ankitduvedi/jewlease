// To parse this JSON data, do
//
//     final fomulaModel = fomulaModelFromJson(jsonString);

import 'dart:convert';

class FormulaModel {
  final String formulaId;
  final List<FomulaRowModel> formulaRows;

  FormulaModel({
    required this.formulaId,
    required this.formulaRows,
  });

  // Optional: Add copyWith method for convenience
  FormulaModel copyWith({
    String? formulaId,
    List<FomulaRowModel>? formulaRows,
  }) {
    return FormulaModel(
      formulaId: formulaId ?? this.formulaId,
      formulaRows: formulaRows ?? this.formulaRows,
    );
  }

// Optional: Add equality checks and toJson/fromJson methods if needed
}


FomulaRowModel fomulaModelFromJson(String str) =>
    FomulaRowModel.fromJson(json.decode(str));

String fomulaModelToJson(FomulaRowModel data) => json.encode(data.toJson());

class FomulaRowModel {
  int editableInd;
  int hideDefaultValueInd;
  dynamic attribTypeAndAttribId;
  int maxRateValue;
  int minRateValue;
  int mrpInd;
  dynamic rangeDtl;
  String rowDescription;
  String rowExpression;
  int rowExpressionId;
  String rowExpressionValue;
  int rowNo;
  String rowStatus;
  String rowType;
  double rowValue;
  dynamic validateExpression;
  int variantId;
  int visibleInd;
  int rateAsPerFormula;
  int id;
  String dataType;

  FomulaRowModel({
    required this.editableInd,
    required this.hideDefaultValueInd,
    required this.attribTypeAndAttribId,
    required this.maxRateValue,
    required this.minRateValue,
    required this.mrpInd,
    required this.rangeDtl,
    required this.rowDescription,
    required this.rowExpression,
    required this.rowExpressionId,
    required this.rowExpressionValue,
    required this.rowNo,
    required this.rowStatus,
    required this.rowType,
    required this.rowValue,
    required this.validateExpression,
    required this.variantId,
    required this.visibleInd,
    required this.rateAsPerFormula,
    required this.id,
    required this.dataType
  });

  factory FomulaRowModel.fromJson(Map<String, dynamic> json) {
    print("json $json");
    return FomulaRowModel(
      editableInd: json["EditableInd"] ?? 0,
      hideDefaultValueInd: json["HideDefaultValueInd"],
      attribTypeAndAttribId: json["Attrib_Type_And_AttribId"],
      maxRateValue: json["MaxRateValue"],
      minRateValue: json["MinRateValue"],
      mrpInd: json["MrpInd"],
      rangeDtl: json["RangeDtl"],
      rowDescription: json["RowDescription"],
      rowExpression: json["RowExpression"],
      rowExpressionId: json["RowExpressionId"],
      rowExpressionValue: json["RowExpressionValue"],
      rowNo: json["RowNo"],
      rowStatus: json["RowStatus"],
      rowType: json["RowType"],
      rowValue: json["RowValue"],
      validateExpression: json["ValidateExpression"],
      variantId: json["VariantID"],
      visibleInd: json["VisibleInd"],
      rateAsPerFormula: json["RateAsPerFormula"],
      id: json["id"],
      dataType: json["dataType"]
    );
  }
  factory FomulaRowModel.fromJson2(Map<String, dynamic> json) {

    return FomulaRowModel(
      editableInd: json["editableInd"] ?? 0,
      hideDefaultValueInd: json["hideDefaultValueInd"],
      attribTypeAndAttribId: json["attribTypeAndAttribId"],  // Updated key
      maxRateValue: json["maxRateValue"],
      minRateValue: json["minRateValue"],
      mrpInd: json["mrpInd"],  // Updated key
      rangeDtl: json["rangeDtl"],  // Updated key
      rowDescription: json["rowDescription"],  // Updated key
      rowExpression: json["rowExpression"],  // Updated key
      rowExpressionId: json["rowExpressionId"],  // Updated key
      rowExpressionValue: json["rowExpressionValue"],  // Updated key
      rowNo: json["rowNo"],  // Updated key
      rowStatus: json["rowStatus"],  // Updated key
      rowType: json["rowType"],  // Updated key
      rowValue: json["rowValue"]*1.0,  // Updated key
      validateExpression: json["validateExpression"],  // Updated key
      variantId: json["variantId"],  // Updated key
      visibleInd: json["visibleInd"],  // Updated key
      rateAsPerFormula: json["rateAsPerFormula"],  // Updated key
      id: json["id"],
      dataType: json["dataType"]// Updated key
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "rowNo": rowNo,
    "mrpInd": mrpInd,
    "rowType": rowType,
    "rangeDtl": rangeDtl,
    "rowValue": rowValue,
    "rowStatus": rowStatus,
    "variantId": variantId,  // Note: Changed from "VariantID" to camelCase
    "visibleInd": visibleInd,
    "editableInd": editableInd,
    "maxRateValue": maxRateValue,
    "minRateValue": minRateValue,
    "rowExpression": rowExpression,
    "rowDescription": rowDescription,
    "rowExpressionId": rowExpressionId,
    "rateAsPerFormula": rateAsPerFormula,
    "rowExpressionValue": rowExpressionValue,
    "validateExpression": validateExpression,
    "hideDefaultValueInd": hideDefaultValueInd,
    "attribTypeAndAttribId": attribTypeAndAttribId,
    "dataType": dataType,  // New field (set to null if not applicable)
  };
}
