import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/core/routes/saving_data.dart';
import 'package:jewlease/data/model/failure.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepository(ref: ref);
});

class SplashRepository {
  SplashRepository({required Ref ref}) : _ref = ref;
  final Ref _ref;

  Future<Either<Failure, bool>> intializeWhile() async {
    try {
      final versionNumber = await getAppVersion();
      final reviewVersionNumber = await getAppReviewVersion();
      debugPrint(
          "version number is $versionNumber and review version number is $reviewVersionNumber");
      if (versionNumber != version && reviewVersionNumber != version) {
        return right(true);
      }
      return right(false);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<String> getAppVersion() async {
    try {
      final data = FirebaseFirestore.instance
          .collection("versions")
          .doc(Platform.isAndroid ? "Android" : "iOS");
      final document = await data.get();
      return document["version"].toString();
    } catch (e) {
      return version;
    }
  }

  Future<String> getAppReviewVersion() async {
    try {
      final platform = (Platform.isAndroid ? "Android" : "iOS");
      final data =
          FirebaseFirestore.instance.collection("review_version").doc(platform);
      final document = await data.get();

      if (document.exists) {
        return document.data()!["version"].toString();
      } else {
        throw Exception("Document not found");
      }
    } catch (e) {
      return "Unknown App Update Error $e";
    }
  }

  Future<Either<Failure, int>> checkCondition() async {
    try {
      // final tempaccessToken =
      //     await SecureStorage().getUserAccessToken('tempAccessToken');

      // if (tempaccessToken != 'onboarded') {
      //   SecureStorage().setUserAccessToken('tempAccessToken', 'onboarded');
      //   return right(1);
      // } else {
      final accessToken =
          await SecureStorage().getUserAccessToken('accessToken');
      if (accessToken != '') {
        //_ref.read(userDataProvider).userData;
        return right(2);
      } else {
        return right(3);
      }
      //}
    } catch (e) {
      log(e.toString());
      return left(Failure(message: e.toString()));
    }
  }
}
