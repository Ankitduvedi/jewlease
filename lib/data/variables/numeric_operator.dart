import 'dart:math';

class NumericValue {
  final double value;

  NumericValue(this.value) {
    if (value < 0) {
      throw ArgumentError("Value cannot be negative: $value");
    }
  }

  // Addition
  NumericValue operator +(NumericValue other) =>
      NumericValue(value + other.value);

  // Subtraction
  NumericValue operator -(NumericValue other) =>
      NumericValue(value - other.value);

  // Multiplication
  NumericValue operator *(NumericValue other) =>
      NumericValue(value * other.value);

  // Division (Handling division by zero)
  NumericValue operator /(NumericValue other) {
    if (other.value == 0) {
      throw ArgumentError("Cannot divide by zero");
    }
    return NumericValue(value / other.value);
  }

  // Modulus
  NumericValue operator %(NumericValue other) {
    if (other.value == 0) {
      throw ArgumentError("Cannot modulo by zero");
    }
    return NumericValue(value % other.value);
  }

  // Power (Exponentiation)
  NumericValue operator ^(NumericValue other) =>
      NumericValue(pow(value, other.value).toDouble());

  // Comparison Operators
  bool operator >(NumericValue other) => value > other.value;
  bool operator <(NumericValue other) => value < other.value;
  bool operator >=(NumericValue other) => value >= other.value;
  bool operator <=(NumericValue other) => value <= other.value;
  @override
  bool operator ==(Object other) =>
      other is NumericValue && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
