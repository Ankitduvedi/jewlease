import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormulaBomNotifier extends StateNotifier<Map<String, dynamic>> {
  FormulaBomNotifier() : super({'data': {}, 'trigger': false});

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

final formulaBomOprProvider =
    StateNotifierProvider<FormulaBomNotifier, Map<String, dynamic>>(
  (ref) => FormulaBomNotifier(),
);



// class FormulaBomNotifier extends StateNotifier<Map<String, dynamic>> {
//   FormulaBomNotifier() : super({'data': {}, 'trigger': false});
//
//   // Function to update the state
//   void updateAction(Map<String, dynamic> newData, bool trigger) {
//     state = {
//       'data': newData,
//       'trigger': trigger,
//     };
//   }
//
//   // Reset the trigger after the action is handled
//   void resetTrigger() {
//     state = {...state, 'trigger': false};
//   }
// }
//
// final formulaBomOprProvider =
// StateNotifierProvider<FormulaBomNotifier, Map<String, dynamic>>(
//       (ref) => FormulaBomNotifier(),
// );