import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jewlease/providers/user_data_provider.dart';

final apisProvider = Provider<APIs>((ref) {
  return APIs(ref: ref);
});

class APIs {
  // for authentication
  final Ref _ref;
  //static FirebaseStorage storage = FirebaseStorage.instance;

  APIs({required Ref ref}) : _ref = ref;
  Future<void> getFirebaseMessagingToken(String id) async {
    log('Push Tokens : ');
    // await FirebaseMessaging.instance.requestPermission();
    // await FirebaseMessaging.instance.getToken().then((t) {
    //   final user = _ref.read(userDataProvider).userData;
    //   if (t != null) {
    //     user!.pushToken = t;
    //     //_ref.read(userDataProvider).updateUserData(user);
    //     FirebaseFirestore.instance.collection('users').doc(id).update({
    //       'push_token': t,
    //     });
    //     log('Push Token: $t');
    //   }
    // });
  }
}
