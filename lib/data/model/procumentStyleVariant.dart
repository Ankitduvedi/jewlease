import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

import '../../feature/procument/repository/procument_Repositoy.dart';

ProcumentStyleVariant procumentStyleVariantFromJson(String str,int index) =>
    ProcumentStyleVariant.fromJson(json.decode(str),index);

String procumentStyleVariantToJson(ProcumentStyleVariant data) =>
    json.encode(data.toJson());

class ProcumentStyleVariant {
  int vairiantIndex;
  String variantName;
  String style;
  String oldVariant;
  String customerVariant;
  String baseVariant;
  String vendor;
  String remark1;
  String vendorVariant;
  String remark2;
  String createdBy;
  double stdBuyingRate;
  double stoneMaxWt;
  String remark;
  double stoneMinWt;
  String karatColor;
  int deliveryDays;
  String forWeb;
  String rowStatus;
  String verifiedStatus;
  int length;
  String codegenSrNo;
  String category;
  String subCategory;
  int styleKarat;
  String variety;
  String hsnSacCode;
  String lineOfBusiness;
  String size;
  String brand;
  String ossasion;
  String gender;
  String sizingPossibility;
  String styleColor;
  String vendorSubProduct;
  String subCluster;
  String bomId;
  List<dynamic> imageDetails;
  String operationId;
  BomModel bomData;
  OperationModel operationData;
  TotalWeight totalWeight;
  TotalMetalWeight totalMetalWeight;
  TotalPeices totalPieces;
  TotalStoneWeight totalStoneWeight;

  ProcumentStyleVariant({
    required this.vairiantIndex,
    required this.variantName,
    required this.style,
    required this.oldVariant,
    required this.customerVariant,
    required this.baseVariant,
    required this.vendor,
    required this.remark1,
    required this.vendorVariant,
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
    required this.variety,
    required this.hsnSacCode,
    required this.lineOfBusiness,
    required this.size,
    required this.brand,
    required this.ossasion,
    required this.gender,
    required this.sizingPossibility,
    required this.styleColor,
    required this.vendorSubProduct,
    required this.subCluster,
    required this.bomId,
    required this.imageDetails,
    required this.operationId,
    required this.bomData,
    required this.operationData,
    required this.totalStoneWeight,
    required this.totalPieces,
    required this.totalMetalWeight,
    required this.totalWeight,
  });

  factory ProcumentStyleVariant.fromJson(
      Map<String, dynamic> json, int variantIndex) {
    // Helper function to parse numeric values that might come as strings
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is String) return double.parse(value);
      return 0;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    final bomId = json["BOM Id"];
    final operationId = json["Operation Id"] ?? "Operation-1";

    return ProcumentStyleVariant(
      vairiantIndex: variantIndex,
      variantName: json["Variant Name"] ?? '',
      style: json["Style"] ?? '',
      oldVariant: json["Old Variant"] ?? '',
      customerVariant: json["Customer Variant"] ?? '',
      baseVariant: json["Base Variant"] ?? '',
      vendor: json["Vendor"] ?? '',
      remark1: json["Remark 1"] ?? '',
      vendorVariant: json["Vendor Variant"] ?? '',
      remark2: json["Remark 2"] ?? '',
      createdBy: json["Created By"] ?? '',
      stdBuyingRate: parseDouble(json["Std Buying Rate"]),
      // Use the helper here
      stoneMaxWt: parseDouble(json["Stone Max Wt"]),
      remark: json["Remark"] ?? '',
      stoneMinWt: parseDouble(json["Stone Min Wt"]),
      karatColor: json["Karat Color"] ?? '',
      deliveryDays: parseInt(json["Delivery Days"]),
      forWeb: json["For Web"] ?? '',
      rowStatus: json["Row Status"] ?? '',
      verifiedStatus: json["Verified Status"] ?? '',
      length: parseInt(json["Length"]),
      codegenSrNo: json["Codegen Sr No"] ?? '',
      category: json["CATEGORY"] ?? '',
      subCategory: json["SUB-CATEGORY"] ?? '',
      styleKarat: parseInt(json["STYLE KARAT"]),
      variety: json["VARIETY"] ?? '',
      hsnSacCode: json["HSN - SAC CODE"] ?? '',
      lineOfBusiness: json["LINE OF BUSINESS"] ?? '',
      size: json["SIZE"] ?? '',
      brand: json["BRAND"] ?? '',
      ossasion: json["OSSASION"] ?? '',
      gender: json["GENDER"] ?? '',
      sizingPossibility: json["SIZING POSSIBILITY"] ?? '',
      styleColor: json["STYLE COLOR"] ?? '',
      vendorSubProduct: json["VENDOR SUB PRODUCT"] ?? '',
      subCluster: json["SUB CLUSTER"] ?? '',
      bomId: bomId ?? '',
      imageDetails:
          List<dynamic>.from(json["Image Details"]?.map((x) => x) ?? []),
      operationId: operationId,
      bomData: BomModel(bomRows: [], headers: []),
      operationData:
          OperationModel(operationId: operationId, operationRows: []),
      totalStoneWeight: TotalStoneWeight(0),
      totalPieces: TotalPeices(0),
      totalMetalWeight: TotalMetalWeight(0),
      totalWeight: TotalWeight(0),
    );
  }

  // Create an async method to initialize the calculated fields
  static Future<ProcumentStyleVariant> initializeCalculatedFields(
      ProcumentStyleVariant variant, int variantIndex) async {
    final bomData = await _calculateBom(variant.bomId);
    final operationData = _calculateOperation(variant.operationId);

    final totalMetalWeight = _calculateTotalMetalWeight(bomData);
    final totalStoneWeight = _calculateTotalStoneWeight(bomData);
    final totalPeices = _calculateTotalPieces(bomData);
    final totalWeight =
        TotalWeight(totalMetalWeight.value + totalStoneWeight.value);

    return ProcumentStyleVariant(
      vairiantIndex: variantIndex,
      variantName: variant.variantName,
      style: variant.style,
      oldVariant: variant.oldVariant,
      customerVariant: variant.customerVariant,
      baseVariant: variant.baseVariant,
      vendor: variant.vendor,
      remark1: variant.remark1,
      vendorVariant: variant.vendorVariant,
      remark2: variant.remark2,
      createdBy: variant.createdBy,
      stdBuyingRate: variant.stdBuyingRate,
      stoneMaxWt: variant.stoneMaxWt,
      remark: variant.remark,
      stoneMinWt: variant.stoneMinWt,
      karatColor: variant.karatColor,
      deliveryDays: variant.deliveryDays,
      forWeb: variant.forWeb,
      rowStatus: variant.rowStatus,
      verifiedStatus: variant.verifiedStatus,
      length: variant.length,
      codegenSrNo: variant.codegenSrNo,
      category: variant.category,
      subCategory: variant.subCategory,
      styleKarat: variant.styleKarat,
      variety: variant.variety,
      hsnSacCode: variant.hsnSacCode,
      lineOfBusiness: variant.lineOfBusiness,
      size: variant.size,
      brand: variant.brand,
      ossasion: variant.ossasion,
      gender: variant.gender,
      sizingPossibility: variant.sizingPossibility,
      styleColor: variant.styleColor,
      vendorSubProduct: variant.vendorSubProduct,
      subCluster: variant.subCluster,
      bomId: variant.bomId,
      imageDetails: variant.imageDetails,
      operationId: variant.operationId,
      bomData: bomData,
      operationData: operationData,
      totalStoneWeight: totalStoneWeight,
      totalPieces: totalPeices,
      totalMetalWeight: totalMetalWeight,
      totalWeight: totalWeight,
    );
  }

  Map<String, dynamic> toJson() => {
        "Variant Name": variantName,
        "Style": style,
        "Old Variant": oldVariant,
        "Customer Variant": customerVariant,
        "Base Variant": baseVariant,
        "Vendor": vendor,
        "Remark 1": remark1,
        "Vendor Variant": vendorVariant,
        "Remark 2": remark2,
        "Created By": createdBy,
        "Std Buying Rate": stdBuyingRate,
        "Stone Max Wt": stoneMaxWt,
        "Remark": remark,
        "Stone Min Wt": stoneMinWt,
        "Karat Color": karatColor,
        "Delivery Days": deliveryDays,
        "For Web": forWeb,
        "Row Status": rowStatus,
        "Verified Status": verifiedStatus,
        "Length": length,
        "Codegen Sr No": codegenSrNo,
        "CATEGORY": category,
        "SUB-CATEGORY": subCategory,
        "STYLE KARAT": styleKarat,
        "VARIETY": variety,
        "HSN - SAC CODE": hsnSacCode,
        "LINE OF BUSINESS": lineOfBusiness,
        "SIZE": size,
        "BRAND": brand,
        "OSSASION": ossasion,
        "GENDER": gender,
        "SIZING POSSIBILITY": sizingPossibility,
        "STYLE COLOR": styleColor,
        "VENDOR SUB PRODUCT": vendorSubProduct,
        "SUB CLUSTER": subCluster,
        "BOM Id": bomId,
        "Image Details": List<dynamic>.from(imageDetails.map((x) => x)),
        "Operation Id": operationId,
        "BOM Data": bomData.toJson(),
        "Operation Data": operationData.toJson(),
      };

  updateVariant(Map<String, dynamic> updatedVarient) {
    bomData = updatedVarient["BOM Data"];
  }

  static TotalMetalWeight _calculateTotalMetalWeight(BomModel bomModel) {
    double totalMetalWeight = 0;
    for (BomRowModel row in bomModel.bomRows) {
      if (row.itemGroup.contains('Metal')) {
        totalMetalWeight += row.weight;
      }
    }
    return TotalMetalWeight(totalMetalWeight);
  }

  static TotalPeices _calculateTotalPieces(BomModel bomModel) {
    return TotalPeices(
        bomModel.bomRows.isNotEmpty ? bomModel.bomRows[0].pieces : 0);
  }

  static TotalStoneWeight _calculateTotalStoneWeight(BomModel bomModel) {
    double totalStoneWeight = 0;
    for (BomRowModel row in bomModel.bomRows) {
      if (row.itemGroup.contains('Stone')) {
        totalStoneWeight += row.weight;
      }
    }
    return TotalStoneWeight(totalStoneWeight);
  }

  static Future<BomModel> _calculateBom(String bomId) async {
    final Dio _dio = Dio();
    List<dynamic> data = await ProcurementRepository(_dio).fetchBom(bomId);
    List<BomRowModel> bomRows = data
        .map((bom) => BomRowModel.fromJson(bom as Map<String, dynamic>))
        .toList();

    return BomModel(bomRows: bomRows, headers: []);
  }

  static OperationModel _calculateOperation(String operationId) {
    List<dynamic> data = operationMapData;
    List<OperationRowModel> operationRows =
        data.map((opr) => OperationRowModel.fromJson(opr)).toList();
    return OperationModel(
        operationId: operationId, operationRows: operationRows);
  }
}




class TotalWeight {
  final double value;

  TotalWeight(this.value);

  @override
  String toString() => 'TotalWeight(value: $value)';
}

class TotalMetalWeight {
  final double value;

  TotalMetalWeight(this.value);

  @override
  String toString() => 'TotalMetalWeight(value: $value)';
}

class TotalPeices {
  final double value;

  TotalPeices(this.value);

  @override
  String toString() => 'TotalPeices(value: $value)';
}

class TotalStoneWeight {
  final double value;

  TotalStoneWeight(this.value);

  @override
  String toString() => 'TotalStoneWeight(value: $value)';
}


final List<Map<String, dynamic>> operationMapData = [
  {
    "OperationId": "Operation-1",
    "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcCF": 0.00,
    "CalcMethod": "WT-CUS",
    "CalcMethodVal": "METAL WT + FINDING WT",
    "CalcQty": 1.00,
    "CalculateFormula": "METAL_WEIGHT * RATE",
    "DepdBOM": null,
    "DepdMethod": null,
    "DepdMethodVal": 0.00,
    "DepdQty": 0.00,
    "LabourAmount": 1500.00,
    "LabourAmountLocal": 1500.00,
    "LabourRate": 500.00,
    "MaxRateValue": 1000.00,
    "MinRateValue": 300.00,
    "Operation": "LABOUR PER NET METAL WEIGHT",
    "OperationType": "NET_METAL",
    "RateAsPerFormula": 500.00,
    "RowStatus": 1,
    "Rate_Edit_Ind": 0
  },
  {
    "OperationId": "Operation-4",
    "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcCF": 0.00,
    "CalcMethod": "PIECE",
    "CalcMethodVal": "TOTAL PIECES",
    "CalcQty": 5.00,
    "CalculateFormula": "PIECES * RATE",
    "DepdBOM": null,
    "DepdMethod": null,
    "DepdMethodVal": 0.00,
    "DepdQty": 0.00,
    "LabourAmount": 1000.00,
    "LabourAmountLocal": 1000.00,
    "LabourRate": 200.00,
    "MaxRateValue": 300.00,
    "MinRateValue": 150.00,
    "Operation": "HALLMARKING",
    "OperationType": "HALLMARK",
    "RateAsPerFormula": 200.00,
    "RowStatus": 1,
    "Rate_Edit_Ind": 0
  },
];