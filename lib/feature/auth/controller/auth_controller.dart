import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/user_model.dart';
import 'package:jewlease/feature/auth/repository/auth_repository.dart';
import 'package:jewlease/providers/api_provider.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref);
});

final toggleSearchStateProvider = StateProvider<int>((ref) {
  return 0; // Initial value is false
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // to tell isLoading state

  Stream<User?> get authStateChange => _authRepository.authStateChange;
  UserModel getUserData(String uid) => _authRepository.getUserData(uid);

  void signOut(BuildContext context) async {
    state = true;
    final response = await _authRepository.signout();
    state = false;
    response.fold((l) => Utils.snackBar(l.message, context), (r) {
      context.pushReplacement('/welcomeScreen');
      null;
    });
  }

  void getSnapshot() {
    _authRepository.getSnapshot();
  }

  void loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    state = true;
    // final user = await _authRepository.loginWithEmailAndPassword(
    //     email, password, context);
    // user.fold((l) => Utils.snackBar(l.message, context), (r) {
    //   _ref
    //       .watch(apisProvider)
    //       .getFirebaseMessagingToken(FirebaseAuth.instance.currentUser!.uid);
    //   context.push('/');
    // });
    context.push('/');
    state = false;
  }

  void signInWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    state = true;
    final response = await _authRepository.signInWithEmailAndPassword(
        email, password, name, context);

    response.fold(
      (l) => Utils.snackBar(l.message, context),
      (r) {
        _ref
            .watch(apisProvider)
            .getFirebaseMessagingToken(FirebaseAuth.instance.currentUser!.uid);
        context.push('/');
      },
    );

    state = false;
  }
}
