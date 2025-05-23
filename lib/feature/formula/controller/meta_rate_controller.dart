import 'package:flutter_riverpod/flutter_riverpod.dart';

final metalRateProvider = StateNotifierProvider<MetalRateNotifier, double>(
      (ref) => MetalRateNotifier(),
);

class MetalRateNotifier extends StateNotifier<double> {
  MetalRateNotifier() : super(0.0);

  void updateRate(double newRate) {
    if (newRate.isNaN) {
      throw ArgumentError('Metal rate cannot be NaN');
    }
    if (newRate < 0) {
      throw ArgumentError('Metal rate cannot be negative');
    }
    if (newRate.isInfinite) {
      throw ArgumentError('Metal rate cannot be infinite');
    }
    print("updated rate $newRate");
    state = newRate;
  }

  void increment(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Increment amount must be positive');
    }
    state += amount;
  }

  void decrement(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Decrement amount must be positive');
    }
    state = (state - amount).clamp(0, double.infinity);
  }

  void reset() {
    state = 0.0;
  }
}


final diamondRateProvider = StateNotifierProvider<MetalRateNotifier, double>(
      (ref) => MetalRateNotifier(),
);

class diamondRateNotifier extends StateNotifier<double> {
  diamondRateNotifier() : super(0.0);

  void updateRate(double newRate) {
    if (newRate.isNaN) {
      throw ArgumentError('Metal rate cannot be NaN');
    }
    if (newRate < 0) {
      throw ArgumentError('Metal rate cannot be negative');
    }
    if (newRate.isInfinite) {
      throw ArgumentError('Metal rate cannot be infinite');
    }
    print("updated rate $newRate");
    state = newRate;
  }

  void increment(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Increment amount must be positive');
    }
    state += amount;
  }

  void decrement(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Decrement amount must be positive');
    }
    state = (state - amount).clamp(0, double.infinity);
  }

  void reset() {
    state = 0.0;
  }
}