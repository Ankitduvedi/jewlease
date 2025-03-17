// To parse this JSON data, do
//
//     final variantMasterStone = variantMasterStoneFromJson(jsonString);

import 'dart:convert';

VariantMasterStone variantMasterStoneFromJson(String str) =>
    VariantMasterStone.fromJson(json.decode(str));

String variantMasterStoneToJson(VariantMasterStone data) =>
    json.encode(data.toJson());

class VariantMasterStone {
  String stoneVariantName;
  String stoneName;
  String manualCodeGen;
  String variantType;
  String oldVariant;
  String customerVariantName;
  String vendorName;
  String tagRemark;
  String stdSellingRate;
  String stdBuyingRate;
  int averageWeight;
  String usedAsBom;
  String mixVariant;
  String rowStatus;
  String verifiedStatus;
  String shape;
  String quality;
  String range;
  String stoneColor;

  VariantMasterStone({
    required this.stoneVariantName,
    required this.stoneName,
    required this.manualCodeGen,
    required this.variantType,
    required this.oldVariant,
    required this.customerVariantName,
    required this.vendorName,
    required this.tagRemark,
    required this.stdSellingRate,
    required this.stdBuyingRate,
    required this.averageWeight,
    required this.usedAsBom,
    required this.mixVariant,
    required this.rowStatus,
    required this.verifiedStatus,
    required this.shape,
    required this.quality,
    required this.range,
    required this.stoneColor,
  });

  factory VariantMasterStone.fromJson(Map<String, dynamic> json) =>
      VariantMasterStone(
        stoneVariantName: json["stoneVariantName"],
        stoneName: json["stoneName"],
        manualCodeGen: json["manualCodeGen"],
        variantType: json["Variant type"],
        oldVariant: json["oldVariant"],
        customerVariantName: json["customerVariantName"],
        vendorName: json["vendorName"],
        tagRemark: json["tagRemark"],
        stdSellingRate: json["stdSellingRate"],
        stdBuyingRate: json["stdBuyingRate"],
        averageWeight: json["averageWeight"],
        usedAsBom: json["usedAsBom"],
        mixVariant: json["mixVariant"],
        rowStatus: json["rowStatus"],
        verifiedStatus: json["verifiedStatus"],
        shape: json["shape"],
        quality: json["quality"],
        range: json["range"],
        stoneColor: json["stoneColor"],
      );

  Map<String, dynamic> toJson() => {
        "stoneVariantName": stoneVariantName,
        "stoneName": stoneName,
        "manualCodeGen": manualCodeGen,
        "variantType": variantType,
        "oldVariant": oldVariant,
        "customerVariantName": customerVariantName,
        "vendorName": vendorName,
        "tagRemark": tagRemark,
        "stdSellingRate": stdSellingRate,
        "stdBuyingRate": stdBuyingRate,
        "averageWeight": averageWeight,
        "usedAsBom": usedAsBom,
        "mixVariant": mixVariant,
        "rowStatus": rowStatus,
        "verifiedStatus": verifiedStatus,
        "shape": shape,
        "quality": quality,
        "range": range,
        "stoneColor": stoneColor,
      };
}
