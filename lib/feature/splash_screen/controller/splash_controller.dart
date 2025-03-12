import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repository/splash_repository.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(
      splashRepository: ref.read(splashRepositoryProvider), ref: ref);
});

class SplashController extends StateNotifier<bool> {
  final SplashRepository _splashRepository;
  final Ref _ref;

  SplashController(
      {required SplashRepository splashRepository, required Ref ref})
      : _splashRepository = splashRepository,
        _ref = ref,
        super(false);

  void checkCondition(BuildContext context) async {
    state = true;

    context.go('/loginScreen');
    state = false;
    return;
  }
}
