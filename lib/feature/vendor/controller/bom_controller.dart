import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/bom_model.dart';
import '../../../data/model/operation_model.dart';



final bomProvider =
    StateNotifierProvider<BOMNotifier, List<BomRowModel>>((ref) {
  return BOMNotifier();
});

class BOMNotifier extends StateNotifier<List<BomRowModel>> {
  BOMNotifier() : super([]);

  // Add a new BomRowModel at the end of the list
  void addRow(BomRowModel newRow) {
    state = [...state, newRow];
  }

  // Update existing BomRowModel that matches the rowNo
  void updateRow(BomRowModel updatedRow) {
    final index = state.indexWhere((row) => row.rowNo == updatedRow.rowNo);
    if (index == -1) {
      throw Exception("Row with rowNo ${updatedRow.rowNo} not found!");
    }
    state = [
      ...state.sublist(0, index),
      updatedRow,
      ...state.sublist(index + 1),
    ];
  }

  // Delete BomRowModel that matches the rowNo
  void deleteRow(int rowNo) {
    state = [
      ...state.sublist(0, rowNo),
      ...state.sublist(rowNo + 1),
    ];
  }
  void updateAll(List<BomRowModel> newList) {
    state = [...newList]; // or just state = newList;
  }

  // Alternative: Clear and add all items
  void replaceAll(List<BomRowModel> newList) {
    print("new list of bom ${newList.length}");
    state = newList;
  }
}
final operationProvider =
StateNotifierProvider<OperationNotifier, List<OperationRowModel>>((ref) {
  return OperationNotifier();
});

class OperationNotifier extends StateNotifier<List<OperationRowModel>> {
  OperationNotifier() : super([]);

  // Add a new OperationRowModel at the end of the list
  void addRow(OperationRowModel newRow) {
    state = [...state, newRow];
  }

  // Update existing OperationRowModel that matches some identifier (like rowNo or id)
  // void updateRow(OperationRowModel updatedRow) {
  //   final index = state.indexWhere((row) => row. == updatedRow.id); // Assuming there's an 'id' field
  //   if (index == -1) {
  //     throw Exception("Row with id ${updatedRow.id} not found!");
  //   }
  //   state = [
  //     ...state.sublist(0, index),
  //     updatedRow,
  //     ...state.sublist(index + 1),
  //   ];
  // }

  // Delete OperationRowModel that matches the identifier
  // void deleteRow(String id) { // Assuming id is String type
  //   state = state.where((row) => row.id != id).toList();
  // }

  // Update the entire list
  void updateAll(List<OperationRowModel> newList) {
    print("new opr list is ${newList.length}");
    state = [...newList];
  }

  // Clear all operations
  void clearAll() {
    state = [];
  }
}