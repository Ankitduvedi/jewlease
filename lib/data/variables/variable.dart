import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jewlease/data/variables/error_provider.dart';

void showError(String message, WidgetRef ref) {
  ref.read(errorStateProvider.notifier).state = message;
}

class Pieces {
  double pieces;

  Pieces(
    this.pieces,
    WidgetRef ref,
  ) {
    if (pieces < 0) {
      showError("Pieces cannot be negative", ref);
      pieces = 1;
    }
    log('pieces: $pieces');
  }
}

class Price {
  final double amount;
  final String currency;

  Price(this.amount, WidgetRef ref, {this.currency = "\$"}) {
    if (amount < 0) {
      showError("Price cannot be negative", ref);
    }
  }

  @override
  String toString() => "$currency$amount";
}

class Weight {
  final double kg;

  Weight(this.kg, WidgetRef ref) {
    if (kg < 0) {
      showError("Weight cannot be negative", ref);
    }
  }

  @override
  String toString() => "$kg kg";
}

class MetalWeight {
  final double grams;

  MetalWeight(this.grams, WidgetRef ref) {
    if (grams < 0) {
      showError("Metal weight cannot be negative", ref);
    }
  }

  Weight toKg(WidgetRef ref) => Weight(grams / 1000, ref);

  @override
  String toString() => "$grams g";
}

class Rate {
  final double perUnit;
  final String unit;

  Rate(this.perUnit, WidgetRef ref, {this.unit = "kg"}) {
    if (perUnit < 0) {
      showError("Rate cannot be negative", ref);
    }
  }

  @override
  String toString() => "\$$perUnit/$unit";
}
