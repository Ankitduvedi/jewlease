class InventoryItemModel {
  String more;
  String itemGroup;
  String variantName;
  String oldVariantName;
  String stockCode;
  String groupCode;
  String qcStatus;
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
  String styleMetalKarat;
  String styleMetalColor;
  String brand;
  String productSizeStock;
  String tablePer;
  String brandStock;
  String vendorCode;
  String vendor;
  String customer;
  int Pieces;
  double metalWeight;
  double netWeight;
  int diaPieces;
  double diaWeight;
  int lgPiece;
  double lgWeight;
  int stonePiece;
  double stoneWeight;
  double sellingLabour;
  String orderNo;
  String karatColor;
  String imageFileName;
  String inwardDocLastTrans;
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
  Map<String, dynamic> bom;
  Map<String, dynamic> operation;
  Map<String, dynamic> formula;
  final String oldVarient;
  final String customerVarient;
  final String baseVarient;
  final String remark1;
  final String vendorVarient;
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

  // Constructor
  InventoryItemModel({
    required this.more,
    required this.itemGroup,
    required this.variantName,
    required this.oldVariantName,
    required this.stockCode,
    required this.groupCode,
    required this.qcStatus,
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
    required this.styleMetalKarat,
    required this.styleMetalColor,
    required this.brand,
    required this.productSizeStock,
    required this.tablePer,
    required this.brandStock,
    required this.vendorCode,
    required this.vendor,
    required this.customer,
    required this.Pieces,
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
    required this.imageFileName,
    required this.inwardDocLastTrans,
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
    required this.formula,
    required this.operation,
    required this.oldVarient,
    required this.customerVarient,
    required this.baseVarient,
    required this.remark1,
    required this.vendorVarient,
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
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    print("json $json");
    try {
      return InventoryItemModel(
        more: json['Remark'] ?? '',
        itemGroup: json['CATEGORY'] ?? '',
        variantName: json['Varient Name'] ?? '',
        oldVariantName: json['Old Varient'] ?? '',
        stockCode: json['Stock ID'] ?? '',
        groupCode: json['Group Code'] ?? '',
        qcStatus: json['Verified Status'] ?? '',
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
        styleMetalKarat: json['Style Metal Karat'] ?? '',
        styleMetalColor: json['Style Metal Color'] ?? '',
        brand: json['Brand'] ?? '',
        productSizeStock: json['Product Size Stock'] ?? '',
        tablePer: json['Table Per'] ?? '',
        brandStock: json['Brand Stock'] ?? '',
        vendorCode: json['Vendor Code'] ?? '',
        vendor: json['Vendor'] ?? '',
        customer: json['Customer'] ?? '',
        Pieces: json['Pieces'] ?? 0,
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
        imageFileName: json['Image Details'].runtimeType == String
            ? json['Image Details']
            : json['Image Details'][0]['url'] ?? '',
        inwardDocLastTrans: json['Inward Doc Last Trans'] ?? '',
        reserveInd: json['Reserve Ind'] ?? false,
        barcodeInd: json['Barcode Ind'] ?? false,
        locationCode: json['Transit Location Code'] ?? '',
        locationName: json['Location Name'] ?? '',
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
        bom: json['BOM'] ?? {},
        formula: json['Formula Details'] ?? {},
        operation: json['Operation'] ?? {},
        oldVarient: json['oldVarient'] ?? '',
        customerVarient: json['customerVarient'] ?? '',
        baseVarient: json['baseVarient'] ?? '',
        remark1: json['remark1'] ?? '',
        vendorVarient: json['vendorVarient'] ?? '',
        remark2: json['remark2'] ?? '',
        createdBy: json['createdBy'] ?? '',
        remark: json['remark'] ?? '',
        deliveryDays: json['deliveryDays'] ?? 0,
        forWeb: json['forWeb'] ?? '',
        rowStatus: json['rowStatus'] ?? '',
        verifiedStatus: json['verifiedStatus'] ?? '',
        length: json['length'] ?? 0,
        codegenSrNo: json['codegenSrNo'] ?? '',
        hsnSacCode: json['hsnSacCode'] ?? '',
        lineOfBusiness: json['lineOfBusiness'] ?? '',
        style: json['style'] ?? '',
        stdBuyingRate: json['Std Buying Rate'] ?? 0,
        stoneMaxWt: json['Stone Max Wt'] ?? 0,
        stoneMinWt: json['Stone Min Wt'] ?? 0,
        department: json['Department'] ?? '',
      );
    } catch (e, stacktrace) {
      print("Error while parsing JSON: $e");
      print("Stacktrace: $stacktrace");
      rethrow; // Re-throw the error after logging
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'style': style,
      'varientName': variantName ?? '',
      'oldVarient': oldVarient ?? '',
      'customerVarient': customerVarient ?? '',
      'baseVarient': baseVarient ?? '',
      'vendor': vendor ?? '',
      'remark1': remark1 ?? '',
      'vendorVarient': vendorVarient ?? '',
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
      'varient': oldVariantName ?? '',
      'hsnSacCode': hsnSacCode ?? '',
      'lineOfBusiness': lob ?? '',
      'bom': bom ?? {},
      // Assuming BOM is another object that needs to be converted
      'formulaDetails': formula ?? {},
      // Assuming formula is another object that needs to be converted
      'imageDetails': [
            {'url': imageFileName}
          ] ??
          '',
      'pieces': Pieces ?? 0,
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
