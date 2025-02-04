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

  /// Add a new BarcodeDetailModel to the list and remove the default if present
  void addBarcodeDetail(BarcodeDetailModel detail) {
    final hasDefault =
        state.isNotEmpty && state.first.stockId == 'xyx'; // Check for default
    if (hasDefault) {
      state = [detail, ...state.skip(1)]; // Replace default with new element
    } else {
      state = [...state, detail]; // Append to the existing list
    }
  }
}

final barcodeDetailListProvider = StateNotifierProvider<
    BarcodeDetailListController, List<BarcodeDetailModel>>(
  (ref) => BarcodeDetailListController(),
);

final barcodeIndexProvider = StateProvider<int>((ref) => 0);
