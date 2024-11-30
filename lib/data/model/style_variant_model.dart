// To parse this JSON data, do
//
// final ItemMasterVariant = ItemMasterVariant(jsonString);

import 'dart:convert';

import 'package:jewlease/data/model/style_item_model.dart';

ItemMasterVariant itemMasterVariantFromJson(String str) =>
    ItemMasterVariant.fromJson(json.decode(str));

String itemMasterStoneToJson(ItemMasterVariant data) =>
    json.encode(data.toJson());

class ItemMasterVariant {
  String style;
  String varientName;
  String oldVarient;
  String customerVarient;
  String baseVarient;
  String vendor;
  String remark1;
  String vendorVarient;
  String remark2;
  String createdBy;
  String stdBuyingRate;
  String stoneMaxWt;
  String remark;
  String stoneMinWt;
  String karatColor;
  int deliveryDays;
  String forWeb;
  String rowStatus;
  String verifiedStatus;
  int length;
  String codegenSrNo;
  String category;
  String subCategory;
  String styleKarat;
  String varient;
  String hsnSacCode;
  String lineOfBusiness;
  dynamic bom;
  dynamic operation;
  List<ImageDetail> imageDetails;

  ItemMasterVariant({
    required this.style,
    required this.varientName,
    required this.oldVarient,
    required this.customerVarient,
    required this.baseVarient,
    required this.vendor,
    required this.remark1,
    required this.vendorVarient,
    required this.remark2,
    required this.createdBy,
    required this.stdBuyingRate,
    required this.stoneMaxWt,
    required this.remark,
    required this.stoneMinWt,
    required this.karatColor,
    required this.deliveryDays,
    required this.forWeb,
    required this.rowStatus,
    required this.verifiedStatus,
    required this.length,
    required this.codegenSrNo,
    required this.category,
    required this.subCategory,
    required this.styleKarat,
    required this.varient,
    required this.hsnSacCode,
    required this.lineOfBusiness,
    required this.bom,
    required this.operation,
    required this.imageDetails,
  });

  factory ItemMasterVariant.fromJson(Map<String, dynamic> json) =>
      ItemMasterVariant(
        style: json["style"],
        varientName: json["variantName"],
        oldVarient: json["oldVarient"],
        customerVarient: json["customerVariant"],
        baseVarient: json["baseVariant"],
        vendor: json["vendor"],
        remark1: json["remark1"],
        vendorVarient: json["vendorVarient"],
        remark2: json["remark2"],
        createdBy: json["createdBy"],
        stdBuyingRate: json["stdBuyingRate"],
        stoneMaxWt: json["stoneMaxWt"],
        remark: json["remark"],
        stoneMinWt: json["stoneMinWt"],
        karatColor: json["karatColor"],
        deliveryDays: json["deliveryDays"],
        forWeb: json["forWeb"],
        rowStatus: json["rowStatus"],
        verifiedStatus: json["verifiedStatus"],
        length: json["length"],
        codegenSrNo: json["codegenSrNo"],
        category: json["category"],
        subCategory: json["subCategory"],
        styleKarat: json["Style Karat"],
        varient: json["variant"],
        hsnSacCode: json["hsnSacCode"],
        lineOfBusiness: json["lineOfBusiness"],
        bom: json["bom"],
        operation: json["operation"],
        imageDetails: List<ImageDetail>.from(
            json["imageDetails"].map((x) => ImageDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style": style,
        "variantName": varientName,
        "oldVarient": oldVarient,
        "customerVariant": customerVarient,
        "baseVariant": baseVarient,
        "vendor": vendor,
        "remark1": remark1,
        "vendorVariant": vendorVarient,
        "remark2": remark2,
        "createdBy": createdBy,
        "stdBuyingRate": stdBuyingRate,
        "stoneMaxWt": stoneMaxWt,
        "remark": remark,
        "stoneMinWt": stoneMinWt,
        "karatColor": karatColor,
        "deliveryDays": deliveryDays,
        "forWeb": forWeb,
        "rowStatus": rowStatus,
        "verifiedStatus": verifiedStatus,
        "length": length,
        "codegenSrNo": codegenSrNo,
        "category": category,
        "subCategory": subCategory,
        "styleKarat": styleKarat,
        "variant": varient,
        "hsnSacCode": hsnSacCode,
        "lineOfBusiness": lineOfBusiness,
        "bom": bom,
        "operation": operation,
        "imageDetails": List<dynamic>.from(imageDetails.map((x) => x.toJson())),
      };
}

// class Bom {
//   String material;
//   String quantity;

//   Bom({
//     required this.material,
//     required this.quantity,
//   });

//   factory Bom.fromJson(Map<String, dynamic> json) => Bom(
//         material: json["material"],
//         quantity: json["quantity"],
//       );

//   Map<String, dynamic> toJson() => {
//         "material": material,
//         "quantity": quantity,
//       };
// }

// class Operation {
//   String time;
//   String process;

//   Operation({
//     required this.time,
//     required this.process,
//   });

//   factory Operation.fromJson(Map<String, dynamic> json) => Operation(
//         time: json["time"],
//         process: json["process"],
//       );

//   Map<String, dynamic> toJson() => {
//         "time": time,
//         "process": process,
//       };
// }
