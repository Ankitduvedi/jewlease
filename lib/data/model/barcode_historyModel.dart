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
    return BarcodeHistoryModel(
        stockId: json['Stock ID'],
        attribute: json['Attribute'],
        varient: json['Varient'],
        transactionNumber: json['Transaction Number'],
        date: json['Date'],
        bom: _calculateBom(json['BOM']),
        operation: _calculateOperation(json["Operation"], ""),
        formula: _calCulateformula(json["Formula"]));
  }

  static OperationModel _calculateOperation(
      Map<String, dynamic> json, String operationId) {
    List<OperationRowModel>? oprRows = (json as List?)
        ?.map((item) => OperationRowModel.fromJson(json))
        .toList();
    return OperationModel(operationId: operationId, operationRows: oprRows!);
  }

  static BomModel _calculateBom(Map<String, dynamic> json) {
    List<BomRowModel>? bomRows =
        (json as List?)?.map((item) => BomRowModel.fromJson(json)).toList();
    BomModel newBom = BomModel(bomRows: bomRows!, headers: []);
    return newBom;
  }

  static FormulaModel? _calCulateformula(Map<String, dynamic> json) {
    return null;
  }
}
