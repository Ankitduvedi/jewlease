import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/transfer/repository/outward_repository.dart';

final dioProvider = Provider((ref) => Dio());

final outwardLocRepositoryProvider = Provider(
  (ref) => OutwardLocRepository(ref.read(dioProvider)),
);

final OutwardLocControllerProvider =
    StateNotifierProvider<OutwardLocController, AsyncValue<void>>((ref) {
  final repository = ref.watch(outwardLocRepositoryProvider);
  return OutwardLocController(repository, ref);
});

class OutwardLocController extends StateNotifier<AsyncValue<void>> {
  final OutwardLocRepository _repository;
  final Ref _ref;

  OutwardLocController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> sendOutwarLocGRN(
      String stockId, String source, String destination) async {
    state = const AsyncValue.loading();
    try {
      final response =
          await _repository.sendOutwardLoc(stockId, source, destination);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<Map<String, dynamic>> fetchGRN(String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchGRN(stockCode);
      return response;

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return {};
    }
  }

  Future<void> updateGRN(
      Map<dynamic, dynamic> grnData, String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.updateGRN(grnData, stockCode);
      // _ref.read(stockCodeProvider.notifier).state = response; // Store stockCode

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteInward(String stockCode) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.deleteInward(stockCode);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
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
