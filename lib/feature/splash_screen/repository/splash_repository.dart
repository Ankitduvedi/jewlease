import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepository(ref: ref);
});

class SplashRepository {
  SplashRepository({required Ref ref});
}
