import 'dart:convert';

import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

class BarcodeHistoryModel {
  final String stockId;
  final String attribute;
  final String varient;
  final String transactionNumber;
  final String date;
  final BomModel? bom;
  final OperationModel? operation;
  final FormulaModel? formula;

  BarcodeHistoryModel({
    required this.stockId,
    required this.attribute,
    required this.varient,
    required this.transactionNumber,
    required this.date,
    required this.bom,
    required this.operation,
    required this.formula,
  });

  // Serialization: Convert the HistoryModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'attribute': attribute,
      'varient': varient,
      'transactionNumber': transactionNumber,
      'date': date,
      'bom': bom,
      'operation': operation,
      'formula': formula,
    };
  }

  // Deserialization: Convert JSON to HistoryModel object
  factory BarcodeHistoryModel.fromJson(Map<String, dynamic> json) {
    print("jsonHistory model  $json");
    print("type is ${json["Operation"]}");
    return BarcodeHistoryModel(
        stockId: json['Stock ID'],
        attribute: json['Attribute'],
        varient: json['Varient'],
        transactionNumber: json['Transaction Number'],
        date: json['Date'],
        bom: _calculateBom( jsonDecode(json['BOM'])),
        operation: _calculateOperation(
            jsonDecode(json["Operation"]), ""),
        formula: _calCulateformula(json["Formula"]));
  }

  static OperationModel? _calculateOperation(
      List<dynamic>json, String operationId) {
    if (json == null) return null;
    List<OperationRowModel>? oprRows = json
        ?.map((item) => OperationRowModel.fromJson(item))
        .toList();
    return OperationModel(operationId: operationId, operationRows: oprRows!);
  }

  static BomModel? _calculateBom(List<dynamic> json) {
    if (json == null) return null;
    List<BomRowModel>? bomRows =
        (json).map((item) => BomRowModel.fromJson2(item)).toList();
    BomModel newBom = BomModel(bomRows: bomRows!, headers: []);
    return newBom;
  }

  static FormulaModel? _calCulateformula(Map<String, dynamic>? json) {
    return null;
  }
}
