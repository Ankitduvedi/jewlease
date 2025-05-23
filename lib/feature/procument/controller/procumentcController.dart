import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';

import '../repository/procument_Repositoy.dart';

final dioProvider = Provider((ref) => Dio());

// Define formulaProcedureRepository
final procurementRepositoryProvider = Provider(
  (ref) => ProcurementRepository(ref.read(dioProvider)),
);

final stockCodeProvider = StateProvider<String>((ref) => "");

final stocksListProvider =
    StateNotifierProvider<StocksListNotifier, List<String>>(
  (ref) => StocksListNotifier(),
);

final procurementControllerProvider =
    StateNotifierProvider<ProcurementController, AsyncValue<void>>((ref) {
  final repository = ref.watch(procurementRepositoryProvider);
  return ProcurementController(repository, ref);
});

class StocksListNotifier extends StateNotifier<List<String>> {
  StocksListNotifier() : super([]);

  void addStockCode(String stockCode) {
    state = [...state, stockCode];
  }
}

class ProcurementController extends StateNotifier<AsyncValue<void>> {
  final ProcurementRepository _repository;
  final Ref _ref;

  ProcurementController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<String> sendGRN(Map<String, dynamic> grnData) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.sendGRN(grnData);
      _ref.read(stockCodeProvider.notifier).state = response; // Store stockCode
      _ref
          .read(stocksListProvider.notifier)
          .addStockCode(response); // Add to stocksList
      return response;
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return "";
    }
  }

  Future<void> updateGRN(Map<String, dynamic> grnData, String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.updateGRN(grnData, stockCode);
      // _ref.read(stockCodeProvider.notifier).state = response; // Store stockCode

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteGRN(String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.deleteGRN(stockCode);
      _ref.read(stockCodeProvider.notifier).state = response; // Store stockCode

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<BomRowModel>> fetchBom(String bomId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchBom(bomId);
      return await response.map((row) => BomRowModel.fromJson(row)).toList();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }
}
