import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/saving_data.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/data/model/user_model.dart';
import 'package:jewlease/providers/user_data_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref: ref);
});

class AuthRepository extends ConsumerStatefulWidget {
  final Ref _ref;

  const AuthRepository({super.key, required Ref ref}) : _ref = ref;

  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      log("registering with email and password");
      final creds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      log("uid is ${creds.user!.uid}");
      SecureStorage().setTempAccessToken('tempAccessToken', 'onboarded');
      SecureStorage().setUserAccessToken('accessToken', creds.user!.uid);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      UserModel userModel;
      userModel = UserModel(
          id: creds.user!.uid,
          name: name,
          isNewUser: true,
          email: email.toString(),
          about: '',
          image:
              'https://firebasestorage.googleapis.com/v0/b/while-2.appspot.com/o/profile_pictures%2FKIHEXrUQrzcWT7aw15E2ho6BNhc2.jpg?alt=media&token=1316edc6-b215-4655-ae0d-20df15555e34',
          createdAt: time,
          pushToken: '',
          dateOfBirth: '',
          gender: '',
          phoneNumber: '',
          place: '',
          designation: 'Member',
          isApproved: 0,
          tourPage: "");
      log('/////as////${FirebaseAuth.instance.currentUser!.uid}');
      await createNewUser(userModel);
      return right(userModel);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Attempt to log in.
      log("logging with email and password");
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Get UID of the logged-in user.
      final String uid = credentials.user!.uid;
      log("logging with email and password Uid = $uid");

      // Fetch user data from Firestore using UID.
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return left(Failure(message: "No account exists for this user."));
      } else {
        // Check if credentials.credential and accessToken are not null
        // String userAccessToken = credentials.credential!.accessToken!.toString();
        SecureStorage().setTempAccessToken('tempAccessToken', 'onboarded');
        SecureStorage().setUserAccessToken('accessToken', uid);
        final UserModel user =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        UserDataProvider userDataProvider =
            UserDataProvider(_ref); // Create an instance
        userDataProvider.updateUserData(user);

        return right(user);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions.
      log(e.toString());
      return left(
          Failure(message: e.message ?? "An error occurred during login."));
    } catch (e) {
      // Handle any other exceptions.
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> signout() async {
    try {
      SecureStorage().setUserAccessToken('accessToken', '');
      await FirebaseAuth.instance.signOut();
      return right(r"Successfully signed out.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        log("Network error: ${e.toString()}");
        return left(Failure(message: "No internet connection available."));
      } else {
        log("FirebaseAuth error: ${e.toString()}");
        return left(Failure(message: "Authentication error: ${e.message}"));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<DocumentSnapshot> getSnapshot() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    return snapshot;
  }

  Future<void> createNewUser(UserModel newUser) async {
    log(' users given id is /: ${newUser.name}');
    log(newUser.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.id)
        .set(newUser.toJson());
    UserDataProvider userDataProvider =
        UserDataProvider(_ref); // Create an instance
    // userDataProvider.setUserData(newUser);
  }

  UserModel getUserData(
    String uid,
  ) {
    UserDataProvider userDataProvider =
        UserDataProvider(_ref); // Create an instance
    UserModel user = userDataProvider.userData!;
    return user;
  }

  Stream<User?> get authStateChange => FirebaseAuth.instance.authStateChanges();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    throw UnimplementedError();
  }
}
