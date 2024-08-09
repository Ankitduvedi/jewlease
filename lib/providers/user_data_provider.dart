// ignore: file_names
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/user_model.dart';

class UserDataProvider with ChangeNotifier {
  final Ref ref;
  late final StreamSubscription<DocumentSnapshot> _userSubscription;
  bool _isDisposed = false;

  UserDataProvider(this.ref) {
    _initData();
  }

  UserModel _userData = UserModel.empty();
  UserModel? get userData => _userData;

  void _initData() {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      // User data subscription
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.uid)
          .snapshots()
          .listen((snapshot) {
        _userUpdateListener(snapshot);
      });
    }
  }

  void _userUpdateListener(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists && !_isDisposed) {
      _userData = UserModel.fromJson(snapshot.data()!);
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _userSubscription.cancel();
    super.dispose();
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.uid)
            .update(updatedUser.toJson());
        _userData = updatedUser;
        _safeNotifyListeners();
      } catch (e) {
        log('Error updating user data: $e');
      }
    }
  }

  fetchUserList() {}
}

final userDataProvider =
    ChangeNotifierProvider.autoDispose<UserDataProvider>((ref) {
  log('userDataProvider');
  return UserDataProvider(ref);
});
