import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/variables/error_provider.dart';
import 'package:jewlease/data/variables/numeric_operator.dart';

void showError(String message, WidgetRef ref) {
  ref.read(errorStateProvider.notifier).state = message;
}

class Pieces extends NumericValue {
  int pieces;

  Pieces(
    this.pieces,
    WidgetRef ref,
  ) : super(0.0) {
    if (pieces < 0) {
      showError("Pieces cannot be negative : $pieces", ref);
      pieces = 1;
    }
  }
}

class Price extends NumericValue {
  final double amount;
  final String currency;

  Price(this.amount, WidgetRef ref, {this.currency = "\$"}) : super(0.0) {
    if (amount < 0) {
      showError("Price cannot be negative : $amount", ref);
    }
  }

  @override
  String toString() => "$currency$amount";
}

class Weight extends NumericValue {
  final double weight;

  Weight(this.weight, WidgetRef ref) : super(0.0) {
    if (weight < 0) {
      showError("Weight cannot be negative : $weight", ref);
    }
  }
}

class ItemWeight extends NumericValue {
  final double itemWeight;

  ItemWeight(this.itemWeight, WidgetRef ref) : super(0.0) {
    if (itemWeight < 0) {
      showError("ItemWeight cannot be negative : $itemWeight", ref);
    }
  }
}

class MetalWeight extends NumericValue {
  final double metalWeight;

  MetalWeight(this.metalWeight, WidgetRef ref) : super(0.0) {
    if (metalWeight < 0) {
      showError("Metal weight cannot be negative : $metalWeight", ref);
    }
  }
}

class StoneWeight extends NumericValue {
  final double stoneWeight;

  StoneWeight(this.stoneWeight, WidgetRef ref) : super(0.0) {
    if (stoneWeight < 0) {
      showError("Stone weight cannot be negative : $stoneWeight", ref);
    }
  }
}

class AvgWeight extends NumericValue {
  final double kg;

  AvgWeight(this.kg, WidgetRef ref) : super(0.0) {
    if (kg < 0) {
      showError("AvgWeight cannot be negative : $kg", ref);
    }
  }
}

class GrossWeight extends NumericValue {
  final double grossWeight;

  GrossWeight(this.grossWeight, WidgetRef ref) : super(0.0) {
    if (grossWeight < 0) {
      showError("GrossWeight  cannot be negative : $grossWeight", ref);
    }
  }
}

class Rate extends NumericValue {
  final double rate;

  Rate(
    this.rate,
    WidgetRef ref,
  ) : super(0.0) {
    if (rate < 0) {
      showError("Rate cannot be negative : $rate", ref);
    }
  }
}

class Amount extends NumericValue {
  final double amount;

  Amount(
    this.amount,
    WidgetRef ref,
  ) : super(0.0) {
    if (amount < 0) {
      showError("Amount cannot be negative : $amount", ref);
    }
  }
}

class Total extends NumericValue {
  final double total;

  Total(
    this.total,
    WidgetRef ref,
  ) : super(0.0) {
    if (total < 0) {
      showError("Total cannot be negative : $total", ref);
    }
  }
}

class SubTotal extends NumericValue {
  final double subTotal;

  SubTotal(
    this.subTotal,
    WidgetRef ref,
  ) : super(0.0) {
    if (subTotal < 0) {
      showError("SubTotal cannot be negative : $subTotal", ref);
    }
  }
}

class DiscountPercent {
  final double discountPercent;

  DiscountPercent(
    this.discountPercent,
    WidgetRef ref,
  ) {
    if (discountPercent < 0) {
      showError("DiscountPercent cannot be negative : $discountPercent", ref);
    }
  }
}

class DiscountAmount {
  final double discountAmount;

  DiscountAmount(
    this.discountAmount,
    WidgetRef ref,
  ) {
    if (discountAmount < 0) {
      showError("DiscountAmount cannot be negative : $discountAmount", ref);
    }
  }
}

class AdjustedAmount {
  final double adjustedAmount;

  AdjustedAmount(
    this.adjustedAmount,
    WidgetRef ref,
  ) {
    if (adjustedAmount < 0) {
      showError("AdjustedAmount cannot be negative : $adjustedAmount", ref);
    }
  }
}

class GST {
  final double gST;

  GST(
    this.gST,
    WidgetRef ref,
  ) {
    if (gST < 0) {
      showError("GST cannot be negative : $gST", ref);
    }
  }
}

class CGST {
  final double cGST;

  CGST(
    this.cGST,
    WidgetRef ref,
  ) {
    if (cGST < 0) {
      showError("CGST cannot be negative : $cGST", ref);
    }
  }
}

class SGST {
  final double sGST;

  SGST(
    this.sGST,
    WidgetRef ref,
  ) {
    if (sGST < 0) {
      showError("CGST cannot be negative : $sGST", ref);
    }
  }
}

class IGST {
  final double iGST;

  IGST(
    this.iGST,
    WidgetRef ref,
  ) {
    if (iGST < 0) {
      showError("CGST cannot be negative : $iGST", ref);
    }
  }
}

class GSTAmount {
  final double gSTAmount;

  GSTAmount(
    this.gSTAmount,
    WidgetRef ref,
  ) {
    if (gSTAmount < 0) {
      showError("CGSTAmount cannot be negative : $gSTAmount", ref);
    }
  }
}

class CGSTAmount {
  final double cGSTAmount;

  CGSTAmount(
    this.cGSTAmount,
    WidgetRef ref,
  ) {
    if (cGSTAmount < 0) {
      showError("CGSTAmount cannot be negative : $cGSTAmount", ref);
    }
  }
}

class SGSTAmount {
  final double sGSTAmount;

  SGSTAmount(
    this.sGSTAmount,
    WidgetRef ref,
  ) {
    if (sGSTAmount < 0) {
      showError("SGSTAmount cannot be negative : $sGSTAmount", ref);
    }
  }
}

class IGSTAmount {
  final double iGSTAmount;

  IGSTAmount(
    this.iGSTAmount,
    WidgetRef ref,
  ) {
    if (iGSTAmount < 0) {
      showError("IGSTAmount cannot be negative : $iGSTAmount", ref);
    }
  }
}

class VariantName {
  final String value;

  VariantName(
    this.value,
  );
}

class ItemGroup {
  final String value;

  ItemGroup(
    this.value,
  );
}
