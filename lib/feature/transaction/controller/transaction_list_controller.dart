import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/inventoryItem.dart';

import '../../../data/model/transaction_model.dart';

class TransactionState {
  final TransactionModel? transaction;
  final Map<String, double> summedValues;

  TransactionState({this.transaction, required this.summedValues});

  TransactionState copyWith({TransactionModel? transaction, Map<String, double>? summedValues}) {
    return TransactionState(
      transaction: transaction ?? this.transaction,
      summedValues: summedValues ?? this.summedValues,
    );
  }
}
class TransactionController extends StateNotifier<TransactionState> {
  TransactionController()
      : super(TransactionState(transaction: null, summedValues: {
    'netWt': 0.0,
    'metalWt': 0.0,
    'totalPieces': 0.0,
    'diaPieces': 0.0,
    'diaWt': 0.0,
  }));

  void saveTransaction(TransactionModel transaction) {
    final summarizedValues = _summarizeValues(transaction);
    state = state.copyWith(transaction: transaction, summedValues: summarizedValues);
  }

  Map<String, double> _summarizeValues(TransactionModel transaction) {
    if (transaction.varients.isEmpty) {
      return {
        'netWt': 0.0,
        'metalWt': 0.0,
        'totalPieces': 0.0,
        'diaPieces': 0.0,
        'diaWt': 0.0,
      };
    }

    double netWt = 0.0;
    double metalWt = 0.0;
    double totalPieces = 0.0;
    double diaPieces = 0.0;
    double diaWt = 0.0;

    for (var variant in transaction.varients) {
      InventoryItemModel inventory = InventoryItemModel.fromJson2(variant);
      netWt += inventory.netWeight ?? 0.0;
      metalWt += inventory.metalWeight ?? 0.0;
      totalPieces += inventory.pieces ?? 0.0;
      diaPieces += inventory.diaPieces ?? 0.0;
      diaWt += inventory.diaWeight ?? 0.0;
    }

    return {
      'netWt': netWt,
      'metalWt': metalWt,
      'totalPieces': totalPieces,
      'diaPieces': diaPieces,
      'diaWt': diaWt,
    };
  }
}


final transactionProvider =
StateNotifierProvider<TransactionController, TransactionState>((ref) {
  return TransactionController();
});

