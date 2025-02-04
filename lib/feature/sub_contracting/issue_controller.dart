import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Repository/issue_stock_repository.dart';

final dioProvider = Provider((ref) => Dio());

final IssueStockRepositoryProvider = Provider(
  (ref) => IssueStockRepository(ref.read(dioProvider)),
);

final IssueStockControllerProvider =
    StateNotifierProvider<IssueStockController, AsyncValue<void>>((ref) {
  final repository = ref.watch(IssueStockRepositoryProvider);
  return IssueStockController(repository, ref);
});

class IssueStockController extends StateNotifier<AsyncValue<void>> {
  final IssueStockRepository _repository;
  final Ref _ref;

  IssueStockController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> sentIssueStock(
      String stockId, String vendor, String operation, String issueDate) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.sentIssueStock(
          stockId, vendor, operation, issueDate);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
