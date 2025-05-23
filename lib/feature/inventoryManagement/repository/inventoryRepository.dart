import 'package:dio/dio.dart';
import 'package:jewlease/core/routes/constant.dart';

class InventoryRepository {
  final Dio _dio;

  InventoryRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchInventory() async {
    final response = await _dio.get('$url2/Procurement/GRN');
    try {
      if (response.statusCode == 200) {
        final data = response.data as List;
        return [sampleInventory];

        data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load inventory data');
      }
    } catch (e) {
      print("error in stock api $e");
      return [];
    }
  }
}

Map<String, dynamic> sampleInventory = {
  "Stock ID": "STC-8",
  "Style": "Style",
  "Variant Name": "GL1-CHAIN-sub karat-CAS-24-1",
  "Old Variant": "oldVariant",
  "Customer Variant": "customerVariant",
  "Base Variant": "baseVariant",
  "Vendor Code": "",
  "Vendor": "Vendor",
  "Location": "Head office",
  "Department": "METAL CONTROL REACT",
  "Remark 1": "remark1",
  "Vendor Variant": "vendorVariant",
  "Remark 2": "remark2",
  "Created By": "2025-05-09T23:59:57.663011",
  "Std Buying Rate": "0",
  "Stone Max Wt": "0",
  "Remark": "remark",
  "Stone Min Wt": "0",
  "Karat Color": "karatColor",
  "Delivery Days": 0,
  "For Web": "forWeb",
  "Row Status": "Active",
  "Verified Status": "verifiedStatus",
  "Length": 0,
  "Codegen Sr No": "codegenSrNo",
  "CATEGORY": "CHAIN",
  "Sub-Category": "sub karat",
  "STYLE KARAT": "24",
  "Variant": "CAS",
  "HSN - SAC CODE": "",
  "LINE OF BUSINESS": "GL1",
  "BOM": [],
  "Operation": null,
  "Image Details": null,
  "Formula Details": null,
  "Pieces": 4,
  "Weight": "20.00",
  "Net Weight": "40.00",
  "Dia Weight": "20.00",
  "Dia Pieces": 0,
  "Location Code": "",
  "Item Group": "",
  "Metal Color": "",
  "Style Metal Color": "",
  "Inward Doc": "trans-92",
  "Last Trans": "",
  "isRawMaterial": 0,
  "Variant Type": "",
  "variantForumalaID": "Formula-87",
  "BOM Id": "BOM-5",
  "OperationId": null,
  "variables": null
};

// Provider for repository
