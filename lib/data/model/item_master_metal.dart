// To parse this JSON data, do
//
//     final itemMasterMetal = itemMasterMetalFromJson(jsonString);

import 'dart:convert';

ItemMasterMetal itemMasterMetalFromJson(String str) =>
    ItemMasterMetal.fromJson(json.decode(str));

String itemMasterMetalToJson(ItemMasterMetal data) =>
    json.encode(data.toJson());

class ItemMasterMetal {
  String metalCode;
  bool exclusiveIndicator;
  String description;
  String rowStatus;
  DateTime createdDate;
  DateTime updateDate;
  String attributeType;
  String attributeValue;

  ItemMasterMetal({
    required this.metalCode,
    required this.exclusiveIndicator,
    required this.description,
    required this.rowStatus,
    required this.createdDate,
    required this.updateDate,
    required this.attributeType,
    required this.attributeValue,
  });

  factory ItemMasterMetal.fromJson(Map<String, dynamic> json) =>
      ItemMasterMetal(
        metalCode: json["Metal code"],
        exclusiveIndicator: json["Exclusive Indicator"] == 1 ? true : false,
        description: json["Description"],
        rowStatus: json["Row status"],
        createdDate: DateTime.parse(json["Created Date"]),
        updateDate: DateTime.parse(json["Update Date"]),
        attributeType: json["Attribute Type"],
        attributeValue: json["Attribute Value"],
      );

  Map<String, dynamic> toJson() => {
        "Metal code": metalCode,
        "Exclusive Indicator": exclusiveIndicator,
        "Description": description,
        "Row status": rowStatus,
        "Created Date":
            "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "Update Date":
            "${updateDate.year.toString().padLeft(4, '0')}-${updateDate.month.toString().padLeft(2, '0')}-${updateDate.day.toString().padLeft(2, '0')}",
        "Attribute Type": attributeType,
        "Attribute Value": attributeValue,
      };
}
