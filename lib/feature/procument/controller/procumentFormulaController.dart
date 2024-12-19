import 'package:flutter_riverpod/flutter_riverpod.dart';

class showFormulaNotifier extends StateNotifier<int> {
  showFormulaNotifier() : super(-1);

  // Function to update the state
  void selectedRow(int rowIndex) {
    state = rowIndex;
  }

  // Reset the trigger after the action is handled
  void resetTrigger() {
    state = -1;
  }
}

final showFormulaProvider = StateNotifierProvider<showFormulaNotifier, int>(
  (ref) => showFormulaNotifier(),
);
