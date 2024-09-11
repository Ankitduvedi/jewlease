// To parse this JSON data, do
//
//     final variantMasterMetal = variantMasterMetalFromJson(jsonString);

import 'dart:convert';

VariantMasterMetal variantMasterMetalFromJson(String str) =>
    VariantMasterMetal.fromJson(json.decode(str));

String variantMasterMetalToJson(VariantMasterMetal data) =>
    json.encode(data.toJson());

class VariantMasterMetal {
  String metalName;
  String variantType;
  String baseMetalVariant;
  double stdSellingRate;
  double stdBuyingRate;
  int reorderQty;
  String usedInBom;
  bool canReturnInMelting;
  String rowStatus;
  DateTime createdDate;
  DateTime updateDate;
  String metalColor;
  String karat;

  VariantMasterMetal({
    required this.metalName,
    required this.variantType,
    required this.baseMetalVariant,
    required this.stdSellingRate,
    required this.stdBuyingRate,
    required this.reorderQty,
    required this.usedInBom,
    required this.canReturnInMelting,
    required this.rowStatus,
    required this.createdDate,
    required this.updateDate,
    required this.metalColor,
    required this.karat,
  });

  factory VariantMasterMetal.fromJson(Map<String, dynamic> json) =>
      VariantMasterMetal(
        metalName: json["Metal name"],
        variantType: json["Variant type"],
        baseMetalVariant: json["Base metal Variant"],
        stdSellingRate: json["Std. selling rate"],
        stdBuyingRate: json["Std. buying rate"],
        reorderQty: json["Reorder Qty"],
        usedInBom: json["Used in BOM"],
        canReturnInMelting: json["Can Return in Melting"],
        rowStatus: json["Row status"],
        createdDate: DateTime.parse(json["Created Date"]),
        updateDate: DateTime.parse(json["Update Date"]),
        metalColor: json["Metal Color"],
        karat: json["Karat"],
      );

  Map<String, dynamic> toJson() => {
        "Metal name": metalName,
        "Variant type": variantType,
        "Base metal Variant": baseMetalVariant,
        "Std. selling rate": stdSellingRate,
        "Std. buying rate": stdBuyingRate,
        "Reorder Qty": reorderQty,
        "Used in BOM": usedInBom,
        "Can Return in Melting": canReturnInMelting,
        "Row status": rowStatus,
        "Created Date": createdDate.toIso8601String(),
        "Update Date": updateDate.toIso8601String(),
        "Metal Color": metalColor,
        "Karat": karat,
      };
}
