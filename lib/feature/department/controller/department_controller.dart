// Define a provider to manage the state of the selected master type
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/feature/department/repository/department_repository.dart';

// Create a StateNotifier for managing the state and interactions
class DepartmentsController extends StateNotifier<bool> {
  final DepartmentsRepository departmentsRepository;

  DepartmentsController(
    this.departmentsRepository,
  ) : super(false);

  Future<void> submitDepartmentsConfiguration(
      Departments config, BuildContext context) async {
    try {
      log('in controller');

      state = true;
      final response = await departmentsRepository.addDepartments(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Department Created', context);
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
final departmentsControllerProvider =
    StateNotifierProvider<DepartmentsController, bool>((ref) {
  final dio = Dio();
  final repository = DepartmentsRepository(dio);
  return DepartmentsController(repository);
});
