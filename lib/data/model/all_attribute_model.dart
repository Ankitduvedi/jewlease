// To parse this JSON data, do
//
//     final allAttribute = allAttributeFromJson(jsonString);

import 'dart:convert';

AllAttribute allAttributeFromJson(String str) =>
    AllAttribute.fromJson(json.decode(str));

String allAttributeToJson(AllAttribute data) => json.encode(data.toJson());

class AllAttribute {
  String attributeType;
  String attributeCode;
  String attributeDescription;
  bool defaultIndicator;
  String rowStatus;

  AllAttribute({
    required this.attributeType,
    required this.attributeCode,
    required this.attributeDescription,
    required this.defaultIndicator,
    required this.rowStatus,
  });

  factory AllAttribute.fromJson(Map<String, dynamic> json) => AllAttribute(
        attributeType: json["AttributeType"],
        attributeCode: json["AttributeCode"],
        attributeDescription: json["AttributeDescription"],
        defaultIndicator: json["DefaultIndicator"],
        rowStatus: json["RowStatus"],
      );

  Map<String, dynamic> toJson() => {
        "AttributeType": attributeType,
        "AttributeCode": attributeCode,
        "AttributeDescription": attributeDescription,
        "DefaultIndicator": defaultIndicator,
        "RowStatus": rowStatus,
      };
}
