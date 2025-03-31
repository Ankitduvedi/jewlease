

// To parse this JSON data, do
//
//     final fomulaModel = fomulaModelFromJson(jsonString);

import 'dart:convert';

FomulaModel fomulaModelFromJson(String str) => FomulaModel.fromJson(json.decode(str));

String fomulaModelToJson(FomulaModel data) => json.encode(data.toJson());

class FomulaModel {
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
  int rowValue;
  dynamic validateExpression;
  int variantId;
  int visibleInd;
  int rateAsPerFormula;
  int id;

  FomulaModel({
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
  });

  factory FomulaModel.fromJson(Map<String, dynamic> json) => FomulaModel(
    editableInd: json["EditableInd"],
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
  );

  Map<String, dynamic> toJson() => {
    "EditableInd": editableInd,
    "HideDefaultValueInd": hideDefaultValueInd,
    "Attrib_Type_And_AttribId": attribTypeAndAttribId,
    "MaxRateValue": maxRateValue,
    "MinRateValue": minRateValue,
    "MrpInd": mrpInd,
    "RangeDtl": rangeDtl,
    "RowDescription": rowDescription,
    "RowExpression": rowExpression,
    "RowExpressionId": rowExpressionId,
    "RowExpressionValue": rowExpressionValue,
    "RowNo": rowNo,
    "RowStatus": rowStatus,
    "RowType": rowType,
    "RowValue": rowValue,
    "ValidateExpression": validateExpression,
    "VariantID": variantId,
    "VisibleInd": visibleInd,
    "RateAsPerFormula": rateAsPerFormula,
    "id": id,
  };
}
