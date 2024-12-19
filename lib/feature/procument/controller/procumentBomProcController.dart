import 'package:flutter_riverpod/flutter_riverpod.dart';

class BomProcNotifier extends StateNotifier<Map<String, dynamic>> {
  BomProcNotifier() : super({'data': {}, 'trigger': false});

  // Function to update the state
  void updateAction(Map<String, dynamic> newData, bool trigger) {
    state = {
      'data': newData,
      'trigger': trigger,
    };
  }

  // Reset the trigger after the action is handled
  void resetTrigger() {
    state = {...state, 'trigger': false};
  }
}

final BomProcProvider =
    StateNotifierProvider<BomProcNotifier, Map<String, dynamic>>(
  (ref) => BomProcNotifier(),
);
