import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/employee/repository/employee_repository.dart';

class DepartmentController extends StateNotifier<List<Departments>> {
  final EmployeeRepository _apiRepository;

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
  return DepartmentController(EmployeeRepository());
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

// Create a StateNotifier for managing the state and interactions
class EmployeeController extends StateNotifier<bool> {
  final EmployeeRepository _employeeRepository;

  EmployeeController(
    this._employeeRepository,
  ) : super(false);

  Future<void> submitEmployeeConfiguration(
      Employee config, BuildContext context) async {
    try {
      log('in controller');

      state = true;
      final response = await _employeeRepository.addEmployee(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Employee Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('error');

      state = false;
    }
  }
}

// Define a provider for the controller
final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, bool>((ref) {
  final repository = EmployeeRepository();
  return EmployeeController(repository);
});
