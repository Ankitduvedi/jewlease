import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/barcode_detail_model.dart';

class BarcodeDetailListController
    extends StateNotifier<List<BarcodeDetailModel>> {
  BarcodeDetailListController()
      : super([
          BarcodeDetailModel(
              stockId: "xyx",
              date: DateTime.now().toIso8601String(),
              transNo: "abc",
              transType: "Transward Inward",
              source: "xyz",
              destination: "REC",
              customer: "Anurag",
              vendor: "xyx",
              sourceDept: "MHCASH",
              destinationDept: "MHCash",
              exchangeRate: 11.33,
              currency: "Rs",
              salesPerson: "Arpit",
              term: "nothing",
              remark: "transward inward ",
              createdBy: "Arpit Verma",
              varient: "xyx",
              postingDate: DateTime.now().toIso8601String())
        ]);

  /// Replace entire barcode detail list with new stock's details
  void setBarcodeDetail(List<BarcodeDetailModel> newDetails) {
    state = newDetails; // Replaces the list completely
  }

  /// Add a new BarcodeDetailModel to the list
  void addBarcodeDetail(BarcodeDetailModel detail) {
    state = [...state, detail]; // Append new detail
  }
}

final barcodeDetailListProvider = StateNotifierProvider<
    BarcodeDetailListController, List<BarcodeDetailModel>>(
  (ref) => BarcodeDetailListController(),
);

final barcodeIndexProvider = StateProvider<int>((ref) => 0);
