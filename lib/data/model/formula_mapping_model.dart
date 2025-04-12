// To parse this JSON data, do
//
//     final fomulaMappigModel = fomulaMappigModelFromJson(jsonString);

import 'dart:convert';

FormulaMappigModel fomulaMappigModelFromJson(String str) =>
    FormulaMappigModel.fromJson(json.decode(str));

String fomulaMappigModelToJson(FormulaMappigModel data) =>
    json.encode(data.toJson());

class FormulaMappigModel {
  String procedureType;
  String transactionType;
  String documentType;
  String transactionCategory;
  String partyName;
  String variantName;
  String itemGroup;
  String attributeType;
  String attributeValue;
  String operation;
  String operationType;
  String procedureName;
  String transType;

  FormulaMappigModel({
    required this.procedureType,
    required this.transactionType,
    required this.documentType,
    required this.transactionCategory,
    required this.partyName,
    required this.variantName,
    required this.itemGroup,
    required this.attributeType,
    required this.attributeValue,
    required this.operation,
    required this.operationType,
    required this.procedureName,
    required this.transType,
  });

  factory FormulaMappigModel.fromJson(Map<String, dynamic> json) =>
      FormulaMappigModel(
        procedureType: json["Procedure Type"],
        transactionType: json["Transaction Type"],
        documentType: json["Document Type"],
        transactionCategory: json["Transaction Category"],
        partyName: json["Party Name"],
        variantName: json["Variant Name"],
        itemGroup: json["Item Group"],
        attributeType: json["Attribute Type"],
        attributeValue: json["Attribute Value"],
        operation: json["Operation"],
        operationType: json["Operation Type"],
        procedureName: json["Procedure Name"],
        transType: json["Trans Type"],
      );

  Map<String, dynamic> toJson() => {
        "procedureType": procedureType,
        "transactionType": transactionType,
        "documentType": documentType,
        "transactionCategory": transactionCategory,
        "partyName": partyName,
        "variantName": variantName,
        "itemGroup": itemGroup,
        "attributeType": attributeType,
        "attributeValue": attributeValue,
        "operation": operation,
        "operationType": operationType,
        "procedureName": procedureName,
        "transType": transType
      };
}
