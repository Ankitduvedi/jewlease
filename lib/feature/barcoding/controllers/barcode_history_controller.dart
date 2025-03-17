import 'dart:developer' show log;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/barcode_historyModel.dart';
import '../repository/barcode_history_repository.dart';

final dioProvider = Provider((ref) => Dio());

final barcodeHistoryRepositoryProvider = Provider(
  (ref) => BarcodeHistoryRepository(ref.read(dioProvider)),
);

final BarocdeHistoryControllerProvider =
    StateNotifierProvider<BarcodeHistoryController, AsyncValue<void>>((ref) {
  final repository = ref.watch(barcodeHistoryRepositoryProvider);
  return BarcodeHistoryController(repository, ref);
});

class BarcodeHistoryController extends StateNotifier<AsyncValue<void>> {
  final BarcodeHistoryRepository _repository;
  final Ref _ref;

  BarcodeHistoryController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> sentBarcodeHistory(BarcodeHistoryModel History) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.sentBarcodeHistory(History);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<BarcodeHistoryModel>> fetchBarcodeHistory(
      String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchBarcodeHistory(stockCode);
      log("response ${response.length}");
      List<BarcodeHistoryModel> NewBarcodeHistorys = [];
      response.forEach((element) {
        NewBarcodeHistorys.add(BarcodeHistoryModel.fromJson(element));
      });
      log("NewBarcodeHistorys ${NewBarcodeHistorys.length}");
      return NewBarcodeHistorys;

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      log("errro in conversion history model $e");
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<List<BarcodeHistoryModel>> fetchAllBarcodeHistory() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchAllBarcodeHistory();
      List<BarcodeHistoryModel> NewBarcodeHistorys = [];
      response.forEach((element) {
        NewBarcodeHistorys.add(BarcodeHistoryModel.fromJson(element));
      });
      return NewBarcodeHistorys;

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<void> deleteGRN(String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.deleteGRN(stockCode);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
