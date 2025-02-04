import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/transaction_model.dart';
import '../repository/transaction_repository.dart';

final dioProvider = Provider((ref) => Dio());

final transactionRepositoryProvider = Provider(
      (ref) => TransactionRepository(ref.read(dioProvider)),
);

final TransactionControllerProvider =
StateNotifierProvider<TransactionController, AsyncValue<void>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionController(repository, ref);
});

class TransactionController extends StateNotifier<AsyncValue<void>> {
  final TransactionRepository _repository;
  final Ref _ref;

  TransactionController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<String?> sentTransaction(TransactionModel transaction) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.sentTransaction(transaction);

      state = const AsyncValue.data(null);
      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<TransactionModel>> fetchTransaction(String transactionID) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchTransaction(transactionID);
      List<TransactionModel> NewBarcodetransactions = [];
      response.forEach((element) {
        NewBarcodetransactions.add(TransactionModel.fromJson(element));
      });
      return NewBarcodetransactions;
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print("error in conversion transaction o model $e");
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }


}
