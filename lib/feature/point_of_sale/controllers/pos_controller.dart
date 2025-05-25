import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/payment.dart';
import 'package:jewlease/feature/point_of_sale/repository/pos_repository.dart';

final dioProvider = Provider((ref) => Dio());

final posRepositoryProvider = Provider(
  (ref) => POSRepository(ref.read(dioProvider)),
);

final posControllerProvider =
    StateNotifierProvider<posController, AsyncValue<void>>((ref) {
  final repository = ref.watch(posRepositoryProvider);
  return posController(repository, ref);
});

class posController extends StateNotifier<AsyncValue<void>> {
  final POSRepository _repository;
  final Ref _ref;
  List<PaymentModel> paymentDetails = [];
  int _currentIndex = 0;

  posController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<String?> addPayment(Map<String, dynamic> payment) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.postPayement(payment);

      state = const AsyncValue.data(null);
      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchPayments(String partyName) async {
    // state = const AsyncValue.loading();
    // try {
      final response = await _repository.fetchPayements(partyName);

      List<PaymentModel> allPayments =
          response.map((row) => PaymentModel.fromJson(row)).toList();
      paymentDetails = allPayments;
      // state = const AsyncValue.data(null);
    // } catch (e, stackTrace) {
    //   print("error in conversion transaction model $e");
    //   state = AsyncValue.error(e, stackTrace);
    // }
  }

  List<PaymentModel> getCurrentPayemnt(String customerName) {
    return paymentDetails
        .where((payment) => payment.partyName == customerName)
        .toList()
      ..sort((payA, payB) => DateTime.parse(payA.transDate)
          .compareTo(DateTime.parse(payB.transDate)));
  }

  List<PaymentModel> fetchLedgers() {
    Map<String, dynamic> parties = {};
    List<PaymentModel> uniquePayments = [];

    for (var payment in paymentDetails) {
      if (!parties.containsKey(payment.partyName)) {
        uniquePayments.add(payment);
      }
    }
    return uniquePayments;
  }
}
