// To parse this JSON data, do
//
//     final itemMasterStone = itemMasterStoneFromJson(jsonString);

import 'dart:convert';

ItemMasterStone itemMasterStoneFromJson(String str) =>
    ItemMasterStone.fromJson(json.decode(str));

String itemMasterStoneToJson(ItemMasterStone data) =>
    json.encode(data.toJson());

class ItemMasterStone {
  String stoneCode;
  String description;
  String rowStatus;
  DateTime createdDate;
  DateTime updateDate;
  String attributeType;
  String attributeValue;

  ItemMasterStone({
    required this.stoneCode,
    required this.description,
    required this.rowStatus,
    required this.createdDate,
    required this.updateDate,
    required this.attributeType,
    required this.attributeValue,
  });

  factory ItemMasterStone.fromJson(Map<String, dynamic> json) =>
      ItemMasterStone(
        stoneCode: json["Stone code"],
        description: json["Description"],
        rowStatus: json["Row status"],
        createdDate: DateTime.parse(json["Created Date"]),
        updateDate: DateTime.parse(json["Update Date"]),
        attributeType: json["Attribute Type"],
        attributeValue: json["Attribute Value"],
      );

  Map<String, dynamic> toJson() => {
        "Stone code": stoneCode,
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
