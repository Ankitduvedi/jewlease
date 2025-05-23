import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

import '../../feature/procument/repository/procument_Repositoy.dart';

ProcumentStyleVariant procumentStyleVariantFromJson(String str, int index) =>
    ProcumentStyleVariant.fromJson(json.decode(str), index);

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
  TotalStoneWeight totalStoneWeight;
  TotalPeices totalPieces;
  TotalPeices totalStonePeices;
  TotalOperationAmount totalOperationAmount;

  String variantFormulaID;
  Map<String, dynamic> variables;
  bool isRawMaterial;
  String more;
  String itemGroup;
  String stockID;
  String groupCode;
  String batchNo;
  String stoneShape;
  String stoneRange;
  String stoneColor;
  String stoneCut;
  String metalKarat;
  String metalColor;
  String lob;
  String styleCollection;
  String projectSizeMaster;
  String styleMetalColor;
  String productSizeStock;
  String tablePer;
  String brandStock;
  String vendorCode;
  String customer;
  int lgPiece;
  double lgWeight;

  String orderNo;
  String inwardDoc;
  bool reserveInd;
  bool barcodeInd;
  String locationCode;
  String locationName;
  String wcGroupName;
  String customerJobworker;
  double halimarking;
  String certificateNo;
  int stockAge;
  bool memoInd;
  DateTime barcodeDate;
  String sorTransItemId;
  String sorTransItemBomId;
  String ownerPartyTypeId;
  String reservePartyId;
  int lineNo;
  String orderPartName;
  int inwardEllapsDays;
  int orderEllapsDays;
  Map<String, dynamic> formulaDetails;
  String department;

  BomModel? oldBom;
  OperationModel? oldOperationModel;

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
    required this.totalWeight,
    required this.totalMetalWeight,
    required this.totalStoneWeight,
    required this.totalPieces,
    required this.totalStonePeices,
    required this.totalOperationAmount,
    required this.variantFormulaID,
    required this.variables,
    required this.isRawMaterial,
    required this.more,
    required this.itemGroup,
    required this.stockID,
    required this.groupCode,
    required this.batchNo,
    required this.stoneShape,
    required this.stoneRange,
    required this.stoneColor,
    required this.stoneCut,
    required this.metalKarat,
    required this.metalColor,
    required this.lob,
    required this.styleCollection,
    required this.projectSizeMaster,
    required this.styleMetalColor,
    required this.productSizeStock,
    required this.tablePer,
    required this.brandStock,
    required this.vendorCode,
    required this.customer,
    required this.lgPiece,
    required this.lgWeight,
    required this.orderNo,
    required this.inwardDoc,
    required this.reserveInd,
    required this.barcodeInd,
    required this.locationCode,
    required this.locationName,
    required this.wcGroupName,
    required this.customerJobworker,
    required this.halimarking,
    required this.certificateNo,
    required this.stockAge,
    required this.memoInd,
    required this.barcodeDate,
    required this.sorTransItemId,
    required this.sorTransItemBomId,
    required this.ownerPartyTypeId,
    required this.reservePartyId,
    required this.lineNo,
    required this.orderPartName,
    required this.inwardEllapsDays,
    required this.orderEllapsDays,
    required this.formulaDetails,
    required this.department,
  });

  factory ProcumentStyleVariant.fromJson(
      Map<String, dynamic> json, int variantIndex) {
    // Helper function to parse numeric values that might come as strings
    double parseDouble(dynamic value) {
      print("double is $value");
      if (value == "") return 0.0;
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
      totalOperationAmount: TotalOperationAmount(0),
      totalStonePeices: TotalPeices(0),
      variantFormulaID: '',
      variables: {},
      isRawMaterial: false,
      // New parameters with default values
      more: json['Remark'] ?? '',
      itemGroup: json['CATEGORY'] ?? '',
      stockID: json['Stock ID'] ?? '',
      groupCode: json['Group Code'] ?? '',
      batchNo: json['Batch No'] ?? '',
      stoneShape: json['Stone Shape'] ?? '',
      stoneRange: json['Stone Range'] ?? '',
      stoneColor: json['Stone Color'] ?? '',
      stoneCut: json['Stone Cut'] ?? '',
      metalKarat: json['STYLE KARAT'] ?? '',
      metalColor: json['Metal Color'] ?? '',
      lob: json['LINE OF BUSINESS'] ?? '',
      styleCollection: json['Style Collection'] ?? '',
      projectSizeMaster: json['Project Size Master'] ?? '',
      styleMetalColor: json['Style Metal Color'] ?? '',
      productSizeStock: json['Product Size Stock'] ?? '',
      tablePer: json['Table Per'] ?? '',
      brandStock: json['Brand Stock'] ?? '',
      vendorCode: json['Vendor Code'] ?? '',
      customer: json['Customer'] ?? '',
      lgPiece: int.parse(json['Lg Piece'] ?? '0'),
      lgWeight: double.parse(json['Lg Weight'] ?? '0'),
      orderNo: json['Order No'] ?? '',
      inwardDoc: json['Inward Doc Last Trans'] ?? '',
      reserveInd: json['Reserve Ind'] ?? false,
      barcodeInd: json['Barcode Ind'] ?? false,
      locationCode: json['Location Code'] ?? '',
      locationName: json['Location'] ?? '',
      wcGroupName: json['WC Group Name'] ?? '',
      customerJobworker: json['Customer Jobworker'] ?? '',
      halimarking: double.parse(json['Halimarking'] ?? '0'),
      certificateNo: json['Certificate No'] ?? '',
      stockAge: json['Stock Age'] ?? 0,
      memoInd: json['Memo Ind'] ?? false,
      barcodeDate:
          DateTime.tryParse(json['Barcode Date'] ?? '') ?? DateTime.now(),
      sorTransItemId: json['Sor Trans Item ID'] ?? '',
      sorTransItemBomId: json['Sor Trans Item BOM ID'] ?? '',
      ownerPartyTypeId: json['Owner Party Type ID'] ?? '',
      reservePartyId: json['Reserve Party ID'] ?? '',
      lineNo: json['Line No'] ?? 0,
      orderPartName: json['Order Part Name'] ?? '',
      inwardEllapsDays: json['Inward Ellaps Days'] ?? 0,
      orderEllapsDays: json['Order Ellaps Days'] ?? 0,
      formulaDetails: json['Formula Details'] ?? {},
      department: json['Department'] ?? '',
    );
  }

  // Create an async method to initialize the calculated fields

  static calculte(ProcumentStyleVariant variant) {
    BomModel bomData = variant.bomData;
    print("recalculate variant metal ");
    final totalMetalWeight = _calculateTotalMetalWeight(bomData);
    final totalStoneWeight = _calculateTotalStoneWeight(bomData);
    final totalPeices = _calculateTotalPieces(bomData);
    final totalWeight =
        TotalWeight(totalMetalWeight.value + totalStoneWeight.value);
    final totalStonePeices = _calculateTotalStonePieces(bomData);
    final totalOperationAmount =
        _calculateOperationAmount(variant.operationData);

    return ProcumentStyleVariant(
      vairiantIndex: variant.vairiantIndex,
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
      bomData: variant.bomData,
      operationData: variant.operationData,
      totalWeight: totalWeight,
      totalMetalWeight: totalMetalWeight,
      totalStoneWeight: totalStoneWeight,
      totalPieces: totalPeices,
      totalStonePeices: totalStonePeices,
      totalOperationAmount: variant.totalOperationAmount,
      variantFormulaID: variant.variantFormulaID,
      variables: variant.variables,
      isRawMaterial: variant.isRawMaterial,
      more: variant.more,
      itemGroup: variant.itemGroup,
      stockID: variant.stockID,
      groupCode: variant.groupCode,
      batchNo: variant.batchNo,
      stoneShape: variant.stoneShape,
      stoneRange: variant.stoneRange,
      stoneColor: variant.stoneColor,
      stoneCut: variant.stoneCut,
      metalKarat: variant.metalKarat,
      metalColor: variant.metalColor,
      lob: variant.lob,
      styleCollection: variant.styleCollection,
      projectSizeMaster: variant.projectSizeMaster,
      styleMetalColor: variant.styleMetalColor,
      productSizeStock: variant.productSizeStock,
      tablePer: variant.tablePer,
      brandStock: variant.brandStock,
      vendorCode: variant.vendorCode,
      customer: variant.customer,
      lgPiece: variant.lgPiece,
      lgWeight: variant.lgWeight,
      orderNo: variant.orderNo,
      inwardDoc: variant.inwardDoc,
      reserveInd: variant.reserveInd,
      barcodeInd: variant.barcodeInd,
      locationCode: variant.locationCode,
      locationName: variant.locationName,
      wcGroupName: variant.wcGroupName,
      customerJobworker: variant.customerJobworker,
      halimarking: variant.halimarking,
      certificateNo: variant.certificateNo,
      stockAge: variant.stockAge,
      memoInd: variant.memoInd,
      barcodeDate: variant.barcodeDate,
      sorTransItemId: variant.sorTransItemId,
      sorTransItemBomId: variant.sorTransItemBomId,
      ownerPartyTypeId: variant.ownerPartyTypeId,
      reservePartyId: variant.reservePartyId,
      lineNo: variant.lineNo,
      orderPartName: variant.orderPartName,
      inwardEllapsDays: variant.inwardEllapsDays,
      orderEllapsDays: variant.orderEllapsDays,
      formulaDetails: variant.formulaDetails,
      department: variant.department,
    );
  }

  static Future<ProcumentStyleVariant> initializeCalculatedFields(
      ProcumentStyleVariant variant, int variantIndex) async {
    final bomData = await _calculateBom(variant.bomId);
    final operationData = await _calculateOperation(variant.operationId);
    print("initialize recalculation variant");

    final totalMetalWeight = _calculateTotalMetalWeight(bomData);
    final totalStoneWeight = _calculateTotalStoneWeight(bomData);
    final totalPeices = _calculateTotalPieces(bomData);
    final totalWeight =
        TotalWeight(totalMetalWeight.value + totalStoneWeight.value);
    final totalStonePeices = _calculateTotalStonePieces(bomData);

    return ProcumentStyleVariant(
      vairiantIndex: variant.vairiantIndex,
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
      totalWeight: totalWeight,
      totalMetalWeight: totalMetalWeight,
      totalStoneWeight: totalStoneWeight,
      totalPieces: totalPeices,
      totalStonePeices: totalStonePeices,
      totalOperationAmount: variant.totalOperationAmount,
      variantFormulaID: variant.variantFormulaID,
      variables: variant.variables,
      isRawMaterial: variant.isRawMaterial,
      more: variant.more,
      itemGroup: variant.itemGroup,
      stockID: variant.stockID,
      groupCode: variant.groupCode,
      batchNo: variant.batchNo,
      stoneShape: variant.stoneShape,
      stoneRange: variant.stoneRange,
      stoneColor: variant.stoneColor,
      stoneCut: variant.stoneCut,
      metalKarat: variant.metalKarat,
      metalColor: variant.metalColor,
      lob: variant.lob,
      styleCollection: variant.styleCollection,
      projectSizeMaster: variant.projectSizeMaster,
      styleMetalColor: variant.styleMetalColor,
      productSizeStock: variant.productSizeStock,
      tablePer: variant.tablePer,
      brandStock: variant.brandStock,
      vendorCode: variant.vendorCode,
      customer: variant.customer,
      lgPiece: variant.lgPiece,
      lgWeight: variant.lgWeight,
      orderNo: variant.orderNo,
      inwardDoc: variant.inwardDoc,
      reserveInd: variant.reserveInd,
      barcodeInd: variant.barcodeInd,
      locationCode: variant.locationCode,
      locationName: variant.locationName,
      wcGroupName: variant.wcGroupName,
      customerJobworker: variant.customerJobworker,
      halimarking: variant.halimarking,
      certificateNo: variant.certificateNo,
      stockAge: variant.stockAge,
      memoInd: variant.memoInd,
      barcodeDate: variant.barcodeDate,
      sorTransItemId: variant.sorTransItemId,
      sorTransItemBomId: variant.sorTransItemBomId,
      ownerPartyTypeId: variant.ownerPartyTypeId,
      reservePartyId: variant.reservePartyId,
      lineNo: variant.lineNo,
      orderPartName: variant.orderPartName,
      inwardEllapsDays: variant.inwardEllapsDays,
      orderEllapsDays: variant.orderEllapsDays,
      formulaDetails: variant.formulaDetails,
      department: variant.department,
    );
  }

  Map<String, dynamic> toJson() => {
        "stockId": "",
        "style": style,
        "varientName": variantName,
        "oldVarient": oldVariant,
        "customerVarient": customerVariant,
        "baseVarient": baseVariant,
        "vendorCode": vendorCode,
        "vendor": vendor,
        "location": locationName,
        "department": department,
        "remark1": remark1,
        "vendorVarient": vendorVariant,
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
        "varient": variety,
        "hsnSacCode": hsnSacCode,
        "lineOfBusiness": lineOfBusiness,
        "SIZE": size,
        "BRAND": brand,
        "OSSASION": ossasion,
        "GENDER": gender,
        "SIZING POSSIBILITY": sizingPossibility,
        "STYLE COLOR": styleColor,
        "VENDOR SUB PRODUCT": vendorSubProduct,
        "SUB CLUSTER": subCluster,
        "pieces": totalPieces.value,
        "weight": totalMetalWeight.value,
        "netWeight": totalWeight.value,
        "diaWeight": totalStoneWeight.value,
        "diaPieces": 0,
        "locationCode": locationCode,
        "itemGroup": itemGroup,
        "metalColor": metalColor,
        "styleMetalColor": styleMetalColor,
        "inwardDoc": inwardDoc,
        "lastTrans": "",
        "isRawMaterial": isRawMaterial,
        "variantType": "",
        "BOM Id": bomId,
        "Image Details": List<dynamic>.from(imageDetails.map((x) => x)),
        "Operation Id": operationId,
        "BOM": bomData.toJson(),
        "operation": operationData.toJson(),
        "variantForumalaID": variantFormulaID,
        "variables": variables
      };

  updateVariant(Map<String, dynamic> updatedVarient) {
    bomData = updatedVarient["BOM Data"] ?? bomData;
    totalOperationAmount =
        updatedVarient["totalOprAmount"] ?? totalOperationAmount;
    totalStonePeices = updatedVarient["totalStonePieces"] ?? totalStonePeices;
    print("update bom done ${bomData.bomRows[0].amount}");
  }

  static TotalMetalWeight _calculateTotalMetalWeight(BomModel bomModel) {
    double totalMetalWeight = 0;
    for (BomRowModel row in bomModel.bomRows) {
      if (row.itemGroup.contains('Metal')) {
        totalMetalWeight += row.weight;
      }
    }
    print("total metal is  $totalMetalWeight");
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

  static TotalPeices _calculateTotalStonePieces(BomModel bomModel) {
    double totalStonePieces = 0;
    for (BomRowModel row in bomModel.bomRows) {
      if (row.itemGroup.contains('Stone')) {
        totalStonePieces += row.pieces;
      }
    }
    return TotalPeices(totalStonePieces);
  }

  static TotalOperationAmount _calculateOperationAmount(
      OperationModel operationModel) {
    double totalOperation = 0;
    totalOperation = operationModel.operationRows
        .map((row) => row.calcQty * row.labourRate)
        .reduce((sum, value) => sum + value);

    return TotalOperationAmount(totalOperation);
  }

  static Future<BomModel> _calculateBom(String bomId) async {
    print("bom id $bomId");
    final Dio _dio = Dio();
    List<dynamic> data = await ProcurementRepository(_dio).fetchBom(bomId);
    List<BomRowModel> bomRows = data
        .map((bom) => BomRowModel.fromJson(bom as Map<String, dynamic>))
        .toList();
    print("bomRows are ${bomRows.length}");

    return BomModel(bomRows: bomRows, headers: []);
  }

  static Future<OperationModel> _calculateOperation(String operationId) async {
    final Dio _dio = Dio();
    List<dynamic> data =
        await ProcurementRepository(_dio).fetchOperation(operationId);

    List<OperationRowModel> operationRows = data
        .map((opr) => OperationRowModel.fromJson(opr as Map<String, dynamic>))
        .toList();
    return OperationModel(
        operationId: operationId, operationRows: operationRows);
  }

  saveVariables(Map<String, dynamic> newVariables) {
    newVariables = newVariables.map((key, value) => MapEntry(
          key,
          (value is double && value.isNaN) ? 0.0 : value,
        ));
    print("cleaned varibles is $newVariables $newVariables");
    variables.addAll(newVariables);
  }

  factory ProcumentStyleVariant.copy(ProcumentStyleVariant other) {
    return ProcumentStyleVariant(
      vairiantIndex: other.vairiantIndex,
      variantName: other.variantName,
      style: other.style,
      oldVariant: other.oldVariant,
      customerVariant: other.customerVariant,
      baseVariant: other.baseVariant,
      vendor: other.vendor,
      remark1: other.remark1,
      vendorVariant: other.vendorVariant,
      remark2: other.remark2,
      createdBy: other.createdBy,
      stdBuyingRate: other.stdBuyingRate,
      stoneMaxWt: other.stoneMaxWt,
      remark: other.remark,
      stoneMinWt: other.stoneMinWt,
      karatColor: other.karatColor,
      deliveryDays: other.deliveryDays,
      forWeb: other.forWeb,
      rowStatus: other.rowStatus,
      verifiedStatus: other.verifiedStatus,
      length: other.length,
      codegenSrNo: other.codegenSrNo,
      category: other.category,
      subCategory: other.subCategory,
      styleKarat: other.styleKarat,
      variety: other.variety,
      hsnSacCode: other.hsnSacCode,
      lineOfBusiness: other.lineOfBusiness,
      size: other.size,
      brand: other.brand,
      ossasion: other.ossasion,
      gender: other.gender,
      sizingPossibility: other.sizingPossibility,
      styleColor: other.styleColor,
      vendorSubProduct: other.vendorSubProduct,
      subCluster: other.subCluster,
      bomId: other.bomId,
      imageDetails: List.from(other.imageDetails),
      operationId: other.operationId,
      bomData: BomModel(
        bomRows: other.bomData.bomRows
            .map((row) => BomRowModel(
                  rowNo: row.rowNo,
                  variantName: row.variantName,
                  itemGroup: row.itemGroup,
                  pieces: row.pieces,
                  weight: row.weight,
                  rate: row.rate,
                  avgWeight: row.avgWeight,
                  amount: row.amount,
                  spChar: row.spChar,
                  operation: row.operation,
                  type: row.type,
                  actions: row.actions,
                  formulaID: row.formulaID,
                ))
            .toList(),
        headers: List.from(other.bomData.headers),
      ),
      operationData: OperationModel(
        operationId: other.operationData.operationId,
        operationRows: other.operationData.operationRows
            .map((row) => OperationRowModel(
                  variantName: row.variantName,
                  calcBom: row.calcBom,
                  calcCf: row.calcCf,
                  calcMethod: row.calcMethod,
                  calcMethodVal: row.calcMethodVal,
                  calcQty: row.calcQty,
                  calculateFormula: row.calculateFormula,
                  depdBom: row.depdBom,
                  depdMethod: row.depdMethod,
                  depdMethodVal: row.depdMethodVal,
                  depdQty: row.depdQty,
                  labourAmount: row.labourAmount,
                  labourAmountLocal: row.labourAmountLocal,
                  labourRate: row.labourRate,
                  maxRateValue: row.maxRateValue,
                  minRateValue: row.minRateValue,
                  operation: row.operation,
                  operationType: row.operationType,
                  rateAsPerFormula: row.rateAsPerFormula,
                  rowStatus: row.rowStatus,
                  rateEditInd: row.rateEditInd,
                ))
            .toList(),
      ),
      totalWeight: TotalWeight(other.totalWeight.value),
      totalMetalWeight: TotalMetalWeight(other.totalMetalWeight.value),
      totalStoneWeight: TotalStoneWeight(other.totalStoneWeight.value),
      totalPieces: TotalPeices(other.totalPieces.value),
      totalStonePeices: TotalPeices(other.totalStonePeices.value),
      totalOperationAmount:
          TotalOperationAmount(other.totalOperationAmount.value),
      variantFormulaID: other.variantFormulaID,
      variables: Map.from(other.variables),
      isRawMaterial: other.isRawMaterial,
      more: other.more,
      itemGroup: other.itemGroup,
      stockID: other.stockID,
      groupCode: other.groupCode,
      batchNo: other.batchNo,
      stoneShape: other.stoneShape,
      stoneRange: other.stoneRange,
      stoneColor: other.stoneColor,
      stoneCut: other.stoneCut,
      metalKarat: other.metalKarat,
      metalColor: other.metalColor,
      lob: other.lob,
      styleCollection: other.styleCollection,
      projectSizeMaster: other.projectSizeMaster,
      styleMetalColor: other.styleMetalColor,
      productSizeStock: other.productSizeStock,
      tablePer: other.tablePer,
      brandStock: other.brandStock,
      vendorCode: other.vendorCode,
      customer: other.customer,
      lgPiece: other.lgPiece,
      lgWeight: other.lgWeight,
      orderNo: other.orderNo,
      inwardDoc: other.inwardDoc,
      reserveInd: other.reserveInd,
      barcodeInd: other.barcodeInd,
      locationCode: other.locationCode,
      locationName: other.locationName,
      wcGroupName: other.wcGroupName,
      customerJobworker: other.customerJobworker,
      halimarking: other.halimarking,
      certificateNo: other.certificateNo,
      stockAge: other.stockAge,
      memoInd: other.memoInd,
      barcodeDate: DateTime.fromMillisecondsSinceEpoch(
          other.barcodeDate.millisecondsSinceEpoch),
      sorTransItemId: other.sorTransItemId,
      sorTransItemBomId: other.sorTransItemBomId,
      ownerPartyTypeId: other.ownerPartyTypeId,
      reservePartyId: other.reservePartyId,
      lineNo: other.lineNo,
      orderPartName: other.orderPartName,
      inwardEllapsDays: other.inwardEllapsDays,
      orderEllapsDays: other.orderEllapsDays,
      formulaDetails: Map.from(other.formulaDetails),
      department: other.department,
    );
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

class TotalOperationAmount {
  final double value;

  TotalOperationAmount(this.value);

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
