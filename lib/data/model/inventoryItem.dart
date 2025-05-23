import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

import '../../feature/procument/repository/procument_Repositoy.dart';

class InventoryItemModel {
  String more;
  String itemGroup;
  String variantName;
  String oldVariant;
  String stockID;
  String groupCode;
  String varifiedStatus;
  String batchNo;
  String stoneShape;
  String stoneRange;
  String stoneColor;
  String stoneCut;
  String metalKarat;
  String metalColor;
  String lob;
  String category;
  String subCategory;
  String styleCollection;
  String projectSizeMaster;
  String styleKarat;
  String styleMetalColor;
  String brand;
  String productSizeStock;
  String tablePer;
  String brandStock;
  String vendorCode;
  String vendor;
  String customer;
  double pieces;
  double metalWeight;
  double netWeight;
  double diaPieces;
  double diaWeight;
  int lgPiece;
  double lgWeight;
  double stonePiece;
  double stoneWeight;
  double sellingLabour;
  String orderNo;
  String karatColor;
  String imageDetails;
  String inwardDoc;
  bool reserveInd;
  bool barcodeInd;
  String locationCode;
  String locationName;
  String wcGroupName;
  String customerJobworker;
  String halimarking;
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
  BomModel bom;
  OperationModel operation;
  Map<String, dynamic> formulaDetails;
  final String oldVarient;
  final String customerVariant;
  final String baseVariant;
  final String remark1;
  final String vendorVariant;
  final String remark2;
  final String createdBy;
  final String remark;
  final int deliveryDays;
  final String forWeb;
  final String rowStatus;
  final String verifiedStatus;
  final int length;
  final String codegenSrNo;
  final String hsnSacCode;
  final String lineOfBusiness;
  final String style;
  final stdBuyingRate;
  final stoneMaxWt;
  final stoneMinWt;
  final department;
  final isRawMaterial;

  // Constructor
  InventoryItemModel({
    required this.more,
    required this.itemGroup,
    required this.variantName,
    required this.oldVariant,
    required this.stockID,
    required this.groupCode,
    required this.varifiedStatus,
    required this.batchNo,
    required this.stoneShape,
    required this.stoneRange,
    required this.stoneColor,
    required this.stoneCut,
    required this.metalKarat,
    required this.metalColor,
    required this.lob,
    required this.category,
    required this.subCategory,
    required this.styleCollection,
    required this.projectSizeMaster,
    required this.styleKarat,
    required this.styleMetalColor,
    required this.brand,
    required this.productSizeStock,
    required this.tablePer,
    required this.brandStock,
    required this.vendorCode,
    required this.vendor,
    required this.customer,
    required this.pieces,
    required this.metalWeight,
    required this.netWeight,
    required this.diaPieces,
    required this.diaWeight,
    required this.lgPiece,
    required this.lgWeight,
    required this.stonePiece,
    required this.stoneWeight,
    required this.sellingLabour,
    required this.orderNo,
    required this.karatColor,
    required this.imageDetails,
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
    required this.bom,
    required this.formulaDetails,
    required this.operation,
    required this.oldVarient,
    required this.customerVariant,
    required this.baseVariant,
    required this.remark1,
    required this.vendorVariant,
    required this.remark2,
    required this.createdBy,
    required this.remark,
    required this.deliveryDays,
    required this.forWeb,
    required this.rowStatus,
    required this.verifiedStatus,
    required this.length,
    required this.codegenSrNo,
    required this.hsnSacCode,
    required this.lineOfBusiness,
    required this.style,
    required this.stdBuyingRate,
    required this.stoneMaxWt,
    required this.stoneMinWt,
    required this.department,
    required this.isRawMaterial,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    log("json $json");
    try {
      return InventoryItemModel(
          more: json['Remark'] ?? '',
          itemGroup: json['CATEGORY'] ?? '',
          variantName: json['Varient Name'] ?? '',
          oldVariant: json['Old Varient'] ?? '',
          stockID: json['Stock ID'] ?? '',
          groupCode: json['Group Code'] ?? '',
          varifiedStatus: json['Verified Status'] ?? '',
          batchNo: json['Batch No'] ?? '',
          stoneShape: json['Stone Shape'] ?? '',
          stoneRange: json['Stone Range'] ?? '',
          stoneColor: json['Stone Color'] ?? '',
          stoneCut: json['Stone Cut'] ?? '',
          metalKarat: json['STYLE KARAT'] ?? '',
          metalColor: json['Metal Color'] ?? '',
          lob: json['LINE OF BUSINESS'] ?? '',
          category: json['CATEGORY'] ?? '',
          subCategory: json['Sub-Category'] ?? '',
          styleCollection: json['Style Collection'] ?? '',
          projectSizeMaster: json['Project Size Master'] ?? '',
          styleKarat: json['Style Metal Karat'] ?? '',
          styleMetalColor: json['Style Metal Color'] ?? '',
          brand: json['Brand'] ?? '',
          productSizeStock: json['Product Size Stock'] ?? '',
          tablePer: json['Table Per'] ?? '',
          brandStock: json['Brand Stock'] ?? '',
          vendorCode: json['Vendor Code'] ?? '',
          vendor: json['Vendor'] ?? '',
          customer: json['Customer'] ?? '',
          pieces: json['Pieces'] ?? 0,
          metalWeight: double.parse(json['Weight'] ?? '0'),
          netWeight: double.parse(json['Net Weight'] ?? '0'),
          diaPieces: json['Dia Pieces'] ?? 0,
          diaWeight: double.parse((json['Dia Weight'] ?? '0')),
          lgPiece: int.parse(json['Lg Piece'] ?? '0'),
          lgWeight: double.parse(json['Lg Weight'] ?? '0'),
          stonePiece: json['Stone Piece'] ?? 0,
          stoneWeight: double.parse(json['Stone Weight'] ?? '0'),
          sellingLabour: (json['Selling Labour'] ?? 0).toDouble(),
          orderNo: json['Order No'] ?? '',
          karatColor: json['Karat Color'] ?? '',
          imageDetails: json['Image Details'].runtimeType == String ? '' : '',
          inwardDoc: json['Inward Doc Last Trans'] ?? '',
          reserveInd: json['Reserve Ind'] ?? false,
          barcodeInd: json['Barcode Ind'] ?? false,
          locationCode: json['Location Code'] ?? '',
          locationName: json['Location'] ?? '',
          wcGroupName: json['WC Group Name'] ?? '',
          customerJobworker: json['Customer Jobworker'] ?? '',
          halimarking: json['Halimarking'] ?? '',
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
          bom: BomModel(
              bomRows: Utils()
                  .sampleBomRows
                  .map((row) => BomRowModel.fromJson(row))
                  .toList(),
              headers: []),
          formulaDetails: json['Formula Details'] ?? {},
          operation: OperationModel(
              operationId: "",
              operationRows: Utils()
                  .oprRows
                  .map((row) => OperationRowModel.fromJson(row))
                  .toList()),
          oldVarient: json['oldVarient'] ?? '',
          customerVariant: json['customerVarient'] ?? '',
          baseVariant: json['baseVarient'] ?? '',
          remark1: json['Remark1'] ?? '',
          vendorVariant: json['vendorVarient'] ?? '',
          remark2: json['Remark2'] ?? '',
          createdBy: json['createdBy'] ?? '',
          remark: json['Remark'] ?? '',
          deliveryDays: json['DeliveryDays'] ?? 0,
          forWeb: json['forWeb'] ?? '',
          rowStatus: json['RowStatus'] ?? '',
          verifiedStatus: json['verifiedStatus'] ?? '',
          length: json['Length'] ?? 0,
          codegenSrNo: json['codegenSrNo'] ?? '',
          hsnSacCode: json['hsnSacCode'] ?? '',
          lineOfBusiness: json['lineOfBusiness'] ?? '',
          style: json['Style'] ?? '',
          stdBuyingRate: json['Std Buying Rate'] ?? 0,
          stoneMaxWt: json['Stone Max Wt'] ?? 0,
          stoneMinWt: json['Stone Min Wt'] ?? 0,
          department: json['Department'] ?? '',
          isRawMaterial: json['isRawMaterial'] ?? false);
    } catch (e, stacktrace) {
      log("Error while parsing JSON: $e");
      log("Stacktrace: $stacktrace");
      rethrow; // Re-throw the error after logging
    }
  }

  Future<BomModel> fetchBom(String bomId) async {
    final Dio _dio = Dio();
    List<dynamic> data = await ProcurementRepository(_dio).fetchBom(bomId);
    List<BomRowModel> bomRows = data
        .map((bom) => BomRowModel.fromJson(bom as Map<String, dynamic>))
        .toList();

    return BomModel(bomRows: bomRows, headers: []);
  }

  OperationModel fetchOperation(List<Map<String, dynamic>> operationRow) {
    List<OperationRowModel> oprRows =
        operationRow.map((row) => OperationRowModel.fromJson(row)).toList();
    return OperationModel(operationId: "", operationRows: oprRows);
  }

  factory InventoryItemModel.fromJson2(Map<String, dynamic> json) {
    print("json $json");
    try {
      return InventoryItemModel(
          bom: json['bom'] ?? {},
          style: json['style'] ?? '',
          forWeb: json['forWeb'] ?? '',
          length: json['length'] ?? 0,
          pieces: json['pieces'] ?? 0,
          remark: json['remark'] ?? '',
          vendor: json['vendor'] ?? '',
          metalWeight:
              double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,
          remark1: json['remark1'] ?? '',
          remark2: json['remark2'] ?? '',
          variantName: json['varientName'] ?? '',
          category: json['category'] ?? '',
          locationName: json['location'] ?? '',
          createdBy: json['createdBy'] ?? '',
          diaPieces: json['diaPieces'] ?? 0,
          diaWeight:
              double.tryParse(json['diaWeight']?.toString() ?? '0') ?? 0.0,
          itemGroup: json['itemGroup'] ?? '',
          netWeight:
              double.tryParse(json['netWeight']?.toString() ?? '0') ?? 0.0,
          operation: json['operation'] ?? {},
          rowStatus: json['rowStatus'] ?? '',
          department: json['department'] ?? '',
          hsnSacCode: json['hsnSacCode'] ?? '',
          karatColor: json['karatColor'] ?? '',
          metalColor: json['metalColor'] ?? '',
          oldVarient: json['oldVarient'] ?? '',
          stoneMaxWt: json['stoneMaxWt'] ?? 0,
          stoneMinWt: json['stoneMinWt'] ?? 0,
          styleKarat: json['styleKarat'] ?? '',
          vendorCode: json['vendorCode'] ?? '',
          baseVariant: json['baseVarient'] ?? '',
          codegenSrNo: json['codegenSrNo'] ?? '',
          subCategory: json['subCategory'] ?? '',
          deliveryDays: json['deliveryDays'] ?? 0,
          imageDetails: json['imageDetails'] != null
              ? (json['imageDetails'].length > 0
                  ? json['imageDetails'][0]["url"]
                  : "")
              : "",
          locationCode: json['loactionCode'] ?? '',
          stdBuyingRate: json['stdBuyingRate'] ?? 0,
          vendorVariant: json['vendorVarient'] ?? '',
          formulaDetails: json['formulaDetails'] ?? {},
          lineOfBusiness: json['lineOfBusiness'] ?? '',
          verifiedStatus: json['verifiedStatus'] ?? '',
          customerVariant: json['customerVarient'] ?? '',
          styleMetalColor: json['styleMetalColor'] ?? '',
          // Added missing parameters from fromJson
          more: json['Remark'] ?? '',
          stockID: json['Stock ID'] ?? '',
          groupCode: json['Group Code'] ?? '',
          varifiedStatus: json['Verified Status'] ?? '',
          batchNo: json['Batch No'] ?? '',
          stoneShape: json['Stone Shape'] ?? '',
          stoneRange: json['Stone Range'] ?? '',
          stoneColor: json['Stone Color'] ?? '',
          stoneCut: json['Stone Cut'] ?? '',
          metalKarat: json['STYLE KARAT'] ?? '',
          lob: json['LINE OF BUSINESS'] ?? '',
          styleCollection: json['Style Collection'] ?? '',
          projectSizeMaster: json['Project Size Master'] ?? '',
          brand: json['Brand'] ?? '',
          productSizeStock: json['Product Size Stock'] ?? '',
          tablePer: json['Table Per'] ?? '',
          brandStock: json['Brand Stock'] ?? '',
          customer: json['Customer'] ?? '',
          lgPiece: int.parse(json['Lg Piece'] ?? '0'),
          lgWeight: double.parse(json['Lg Weight'] ?? '0'),
          stonePiece: json['Stone Piece'] ?? 0,
          stoneWeight: double.parse(json['Stone Weight'] ?? '0'),
          sellingLabour: (json['Selling Labour'] ?? 0).toDouble(),
          orderNo: json['Order No'] ?? '',
          inwardDoc: json['Inward Doc Last Trans'] ?? '',
          reserveInd: json['Reserve Ind'] ?? false,
          barcodeInd: json['Barcode Ind'] ?? false,
          wcGroupName: json['WC Group Name'] ?? '',
          customerJobworker: json['Customer Jobworker'] ?? '',
          halimarking: json['Halimarking'] ?? '',
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
          oldVariant: '',
          isRawMaterial: json['isRawMaterial'] ?? false);
    } catch (e, stacktrace) {
      print("Error while parsing JSON: $e");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'style': style,
      'varientName': variantName ?? '',
      'oldVarient': oldVarient ?? '',
      'customerVarient': customerVariant ?? '',
      'baseVarient': baseVariant ?? '',
      'vendor': vendor ?? '',
      'remark1': remark1 ?? '',
      'vendorVarient': vendorVariant ?? '',
      'remark2': remark2 ?? '',
      'createdBy': createdBy ?? '',
      'remark': remark ?? '',
      'stoneMaxWt': stoneMaxWt ?? '',
      'stoneMinWt': stoneMinWt ?? '',
      'karatColor': karatColor ?? '',
      'deliveryDays': deliveryDays ?? 0,
      'forWeb': forWeb ?? '',
      'rowStatus': rowStatus ?? '',
      'verifiedStatus': verifiedStatus ?? '',
      'length': length ?? 0,
      'codegenSrNo': codegenSrNo ?? '',
      'category': category ?? '',
      'subCategory': subCategory ?? '',
      'subKarat': metalKarat ?? '',
      'varient': oldVariant ?? '',
      'hsnSacCode': hsnSacCode ?? '',
      'lineOfBusiness': lob ?? '',
      'bom': bom ?? {},
      'operation': operation ?? {},
      // Assuming BOM is another object that needs to be converted
      'formulaDetails': formulaDetails ?? {},
      // Assuming formula is another object that needs to be converted
      'imageDetails': [
            {'url': imageDetails}
          ] ??
          '',
      'pieces': pieces ?? 0,
      'weight': metalWeight?.toString() ?? '0',
      'netWeight': netWeight?.toString() ?? '0',
      'diaPieces': diaPieces ?? 0,
      'diaWeight': diaWeight?.toString() ?? '0',
      'loactionCode': locationCode ?? '',
      'location': locationName ?? '',
      'department': department ?? '',
      'itemGroup': itemGroup ?? '',
      'metalColor': metalColor ?? '',
      'styleMetalColor': styleMetalColor ?? '',
    };
  }
}
