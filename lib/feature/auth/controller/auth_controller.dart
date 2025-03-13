import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/auth/repository/auth_repository.dart';

// Auth provider to store user session
final authProvider = StateProvider<Employee?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _loginRepository;

  AuthController(
    this._loginRepository,
  ) : super(false);

  Future<void> login(String username, String password, BuildContext context,
      WidgetRef ref) async {
    try {
      log('in controller');

      state = true;
      final response = await _loginRepository.login(username, password);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (employee) {
        log('login successfull employee $employee');
        ref.read(authProvider.notifier).state = employee;
        goRouter.go('/');
        Utils.snackBar('login successfull', context);
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
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final repository = AuthRepository();
  return AuthController(
    repository,
  );
});
