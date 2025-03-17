import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/barcode_detail_model.dart';
import 'package:jewlease/feature/barcoding/repository/barcode_detail_repostiory.dart';

final dioProvider = Provider((ref) => Dio());

final barcodeDetailRepositoryProvider = Provider(
  (ref) => BarcodeDetailRepository(ref.read(dioProvider)),
);

final BarocdeDetailControllerProvider =
    StateNotifierProvider<BarcodeDetailController, AsyncValue<void>>((ref) {
  final repository = ref.watch(barcodeDetailRepositoryProvider);
  return BarcodeDetailController(repository, ref);
});

class BarcodeDetailController extends StateNotifier<AsyncValue<void>> {
  final BarcodeDetailRepository _repository;
  final Ref _ref;

  BarcodeDetailController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> sentBarcodeDetail(BarcodeDetailModel detail) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.sentBarcodeDetail(detail);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<BarcodeDetailModel>> fetchBarcodeDetail(String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchBarcodeDetail(stockCode);
      List<BarcodeDetailModel> NewBarcodeDetails = [];
      response.forEach((element) {
        NewBarcodeDetails.add(BarcodeDetailModel.fromJson(element));
      });
      return NewBarcodeDetails;
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print("error in conversion detail o model $e");
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<List<BarcodeDetailModel>> fetchAllBarcodeDetail() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchAllBarcodeDetail();
      List<BarcodeDetailModel> NewBarcodeDetails = [];
      response.forEach((element) {
        NewBarcodeDetails.add(BarcodeDetailModel.fromJson(element));
      });
      return NewBarcodeDetails;

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
