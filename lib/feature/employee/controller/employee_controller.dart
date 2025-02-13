import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/employee/repository/employee_repository.dart';

class DepartmentController extends StateNotifier<List<Departments>> {
  final ApiRepository _apiRepository;

  DepartmentController(this._apiRepository) : super([]);

  Future<void> fetchDepartments(String apiUrl) async {
    try {
      final data = await _apiRepository.fetchData(apiUrl);
      state = data.map((e) => Departments.fromJson(e)).toList();
    } catch (e) {
      state = [];
    }
  }
}

// Provider for department controller
final departmentProvider =
    StateNotifierProvider<DepartmentController, List<Departments>>((ref) {
  return DepartmentController(ApiRepository());
});

class SelectedLocationNotifier extends StateNotifier<Location?> {
  SelectedLocationNotifier() : super(null);

  void setLocation(Location location) {
    state = location;
  }
}

final selectedLocationProvider =
    StateNotifierProvider<SelectedLocationNotifier, Location?>(
        (ref) => SelectedLocationNotifier());

class MultiSelectionNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MultiSelectionNotifier() : super([]);

  void toggleSelection(Map<String, dynamic> item) {
    state = state.contains(item)
        ? state.where((e) => e != item).toList()
        : [...state, item];
  }

  void clearSelection() {
    state = [];
  }
}

final newdialogSelectionProvider =
    StateNotifierProvider<MultiSelectionNotifier, List<Map<String, dynamic>>>(
  (ref) => MultiSelectionNotifier(),
);
