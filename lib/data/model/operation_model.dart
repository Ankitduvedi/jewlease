// To parse this JSON data, do
//
//     final operationModel = operationModelFromJson(jsonString);

import 'dart:convert';

OperationRowModel operationModelFromJson(String str) =>
    OperationRowModel.fromJson(json.decode(str));

String operationModelToJson(OperationRowModel data) =>
    json.encode(data.toJson());

class OperationRowModel {
  String variantName;
  String calcBom;
  double calcCf;
  String calcMethod;
  String calcMethodVal;
  double calcQty;
  String calculateFormula;
  dynamic depdBom;
  dynamic depdMethod;
  double depdMethodVal;
  double depdQty;
  double labourAmount;
  double labourAmountLocal;
  double labourRate;
  double maxRateValue;
  double minRateValue;
  String operation;
  dynamic operationType;
  double rateAsPerFormula;
  int rowStatus;
  int rateEditInd;

  OperationRowModel({
    required this.variantName,
    required this.calcBom,
    required this.calcCf,
    required this.calcMethod,
    required this.calcMethodVal,
    required this.calcQty,
    required this.calculateFormula,
    required this.depdBom,
    required this.depdMethod,
    required this.depdMethodVal,
    required this.depdQty,
    required this.labourAmount,
    required this.labourAmountLocal,
    required this.labourRate,
    required this.maxRateValue,
    required this.minRateValue,
    required this.operation,
    required this.operationType,
    required this.rateAsPerFormula,
    required this.rowStatus,
    required this.rateEditInd,
  });

  OperationRowModel copyWith({
    String? variantName,
    String? calcBom,
    double? calcCf,
    String? calcMethod,
    String? calcMethodVal,
    double? calcQty,
    String? calculateFormula,
    dynamic depdBom,
    dynamic depdMethod,
    double? depdMethodVal,
    double? depdQty,
    double? labourAmount,
    double? labourAmountLocal,
    double? labourRate,
    double? maxRateValue,
    double? minRateValue,
    String? operation,
    dynamic operationType,
    double? rateAsPerFormula,
    int? rowStatus,
    int? rateEditInd,
  }) {
    return OperationRowModel(
      variantName: variantName ?? this.variantName,
      calcBom: calcBom ?? this.calcBom,
      calcCf: calcCf ?? this.calcCf,
      calcMethod: calcMethod ?? this.calcMethod,
      calcMethodVal: calcMethodVal ?? this.calcMethodVal,
      calcQty: calcQty ?? this.calcQty,
      calculateFormula: calculateFormula ?? this.calculateFormula,
      depdBom: depdBom ?? this.depdBom,
      depdMethod: depdMethod ?? this.depdMethod,
      depdMethodVal: depdMethodVal ?? this.depdMethodVal,
      depdQty: depdQty ?? this.depdQty,
      labourAmount: labourAmount ?? this.labourAmount,
      labourAmountLocal: labourAmountLocal ?? this.labourAmountLocal,
      labourRate: labourRate ?? this.labourRate,
      maxRateValue: maxRateValue ?? this.maxRateValue,
      minRateValue: minRateValue ?? this.minRateValue,
      operation: operation ?? this.operation,
      operationType: operationType ?? this.operationType,
      rateAsPerFormula: rateAsPerFormula ?? this.rateAsPerFormula,
      rowStatus: rowStatus ?? this.rowStatus,
      rateEditInd: rateEditInd ?? this.rateEditInd,
    );
  }

  factory OperationRowModel.fromJson(Map<String, dynamic> json) =>
      OperationRowModel(
        variantName: json["VariantName"] ?? "",
        calcBom: json["CalcBOM"] ?? "",
        calcCf: double.parse(json["CalcCF"].toString()) ?? 0,
        calcMethod: json["CalcMethod"] ?? "",
        calcMethodVal: json["CalcMethodVal"] ?? "",
        calcQty: double.tryParse( json["CalcQty"]) ?? 0.0,
        calculateFormula: json["CalculateFormula"] ?? "",
        depdBom: json["DepdBOM"],
        depdMethod: json["DepdMethod"],
        depdMethodVal: double.parse( json["DepdMethodVal"]) ?? 0,
        depdQty: double.parse(json["DepdQty"]) ?? 0,
        labourAmount: double.parse(json["LabourAmount"]) ?? 0,
        labourAmountLocal: double.parse(json["LabourAmountLocal"]) ?? 0,
        labourRate:double.parse( json["LabourRate"]) ?? 0,
        maxRateValue: double.parse(json["MaxRateValue"]) ?? 0,
        minRateValue: double.parse(json["MinRateValue"]) ?? 0,
        operation: json["Operation"] ?? "",
        operationType: json["OperationType"],
        rateAsPerFormula: double.parse(json["RateAsPerFormula"]) ?? 0,
        rowStatus: json["RowStatus"] ?? 0,
        rateEditInd: json["Rate_Edit_Ind"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "VariantName": variantName,
        "CalcBOM": calcBom,
        "CalcCF": calcCf,
        "CalcMethod": calcMethod,
        "CalcMethodVal": calcMethodVal,
        "CalcQty": calcQty,
        "CalculateFormula": calculateFormula,
        "DepdBOM": depdBom,
        "DepdMethod": depdMethod,
        "DepdMethodVal": depdMethodVal,
        "DepdQty": depdQty,
        "LabourAmount": labourAmount,
        "LabourAmountLocal": labourAmountLocal,
        "LabourRate": labourRate,
        "MaxRateValue": maxRateValue,
        "MinRateValue": minRateValue,
        "Operation": operation,
        "OperationType": operationType,
        "RateAsPerFormula": rateAsPerFormula,
        "RowStatus": rowStatus,
        "Rate_Edit_Ind": rateEditInd,
      };

  static OperationRowModel fromDatagrid(
      OperationRowModel oprModel, List<dynamic> values) {
    return OperationRowModel(
      variantName: oprModel.variantName,
      calcBom: values[0],
      calcCf: oprModel.calcCf,
      calcMethod: values[5],
      calcMethodVal: oprModel.calcMethodVal,
      calcQty: values[2],
      calculateFormula: oprModel.calculateFormula,
      depdBom: oprModel.depdBom,
      depdMethod: oprModel.depdMethod,
      depdMethodVal: oprModel.depdMethodVal,
      depdQty: oprModel.depdQty,
      labourAmount: values[4],
      labourAmountLocal: oprModel.labourAmountLocal,
      labourRate: values[3],
      maxRateValue: oprModel.maxRateValue,
      minRateValue: oprModel.minRateValue,
      operation: values[1],
      operationType: oprModel.operation,
      rateAsPerFormula: oprModel.rateAsPerFormula,
      rowStatus: oprModel.rowStatus,
      rateEditInd: oprModel.rateEditInd,
    );
  }

  static OperationRowModel fromNewDatagrid(List<dynamic> values) {
    return OperationRowModel(
        variantName: '',
        calcBom: values[0],
        calcCf: 0,
        calcMethod: '',
        calcMethodVal: values[5],
        calcQty: values[2],
        calculateFormula: '',
        depdBom: '',
        depdMethod: '',
        depdMethodVal: 0,
        depdQty: 0,
        labourAmount: values[4],
        labourAmountLocal: 0,
        labourRate: values[3],
        maxRateValue: 0,
        minRateValue: 0,
        operation: values[1],
        operationType: '',
        rateAsPerFormula: 0,
        rowStatus: 1,
        rateEditInd: 1);
  }
}

class OperationModel {
  String operationId;
  List<OperationRowModel> operationRows;

  OperationModel({
    required this.operationId,
    required this.operationRows,
  });

  List<Map<String, dynamic>> toJson() {
    return List<Map<String, dynamic>>.from(
        operationRows.map((x) => x.toJson()));
  }
}
