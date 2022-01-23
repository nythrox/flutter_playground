import 'package:mobx/mobx.dart';

class ObservableDouble implements Observable<double>{
  final Observable<double> obs;
  double get value => obs.value;
  ObservableDouble(double initialValue,
      {String name,
      ReactiveContext context,
      bool Function(double, double) equals})
      : obs = Observable(initialValue,
            name: name, context: context, equals: equals);

  /// Provide a representation of this [double] value.
  ///
  /// The representation is a number literal such that the closest double value
  /// to the representation's mathematical value is this [double].
  ///
  /// Returns "NaN" for the Not-a-Number value.
  /// Returns "Infinity" and "-Infinity" for positive and negative Infinity.
  /// Returns "-0.0" for negative zero.
  ///
  /// For all doubles, `d`, converting to a string and parsing the string back
  /// gives the same value again: `d == double.parse(d.toString())` (except when
  /// `d` is NaN).
  @override
  String toString() => value.toString();

  double remainder(num other) => value.remainder(other);

  double operator +(num other) => value + other;

  double operator -(num other) => value - other;

  double operator *(num other) => value * other;

  double operator %(num other) => value % other;

  double operator /(num other) => value / other;

  int operator ~/(num other) => value ~/ other;

  double operator -() => -value;

  double abs() => value.abs();

  /// Returns the sign of the double's numerical value.
  ///
  /// Returns -1.0 if the value is less than zero,
  /// +1.0 if the value is greater than zero,
  /// and the value itself if it is -0.0, 0.0 or NaN.
  double get sign => value.sign;

  /// Returns the integer closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity), .
  int round() => value.round();

  /// Returns the greatest integer no greater than this number.
  ///
  /// Rounds the number towards negative infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or infinity), .
  int floor() => value.floor();

  /// Returns the least integer which is not smaller than this number.
  ///
  /// Rounds the number towards infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity), .
  int ceil() => value.ceil();

  /// Returns the integer obtained by discarding any fractional
  /// part of this number.
  ///
  /// Rounds the number towards zero.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity), .
  int truncate() => value.truncate();

  /// Returns the integer double value closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).roundToDouble() == 4` and `(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value, `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  double roundToDouble() => value.roundToDouble();

  /// Returns the greatest integer double value no greater than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `0.0 < d < 1.0` will return `0.0`.
  double floorToDouble() => value.floorToDouble();

  /// Returns the least integer double value no smaller than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns the integer double value obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`, and
  /// in the range `0.0 < d < 1.0` it will return 0.0.
  double truncateToDouble() => value.truncateToDouble();


  /// A string representation with [precision] significant digits.
  ///
  /// Converts this number to a [double]
  /// and returns a string representation of that value
  /// with exactly [precision] significant digits.
  ///
  /// The parameter [precision] must be an integer satisfying:
  /// `1 <= precision <= 21`.
  ///
  /// Examples:
  /// ```dart
  /// 1.toStringAsPrecision(2);       // 1.0
  /// 1e15.toStringAsPrecision(3);    // 1.00e+15
  /// 1234567.toStringAsPrecision(3); // 1.23e+6
  /// 1234567.toStringAsPrecision(9); // 1234567.00
  /// 12345678901234567890.toStringAsPrecision(20); // 12345678901234567168
  /// 12345678901234567890.toStringAsPrecision(14); // 1.2345678901235e+19
  /// 0.00000012345.toStringAsPrecision(15); // 1.23450000000000e-7
  /// 0.0000012345.toStringAsPrecision(15);  // 0.00000123450000000000
  /// ```
  String toStringAsPrecision(int precision) => value.toStringAsPrecision(precision);

  
  /// An exponential string-representation of this number.
  ///
  /// Converts this number to a [double]
  /// before computing the string representation.
  ///
  /// If [fractionDigits] is given then it must be an integer satisfying:
  /// `0 <= fractionDigits <= 20`. In this case the string contains exactly
  /// [fractionDigits] after the decimal point. Otherwise, without the parameter,
  /// the returned string uses the shortest number of digits that accurately
  /// represent this number.
  ///
  /// If [fractionDigits] equals 0 then the decimal point is omitted.
  /// Examples:
  /// ```dart
  /// 1.toStringAsExponential();       // 1e+0
  /// 1.toStringAsExponential(3);      // 1.000e+0
  /// 123456.toStringAsExponential();  // 1.23456e+5
  /// 123456.toStringAsExponential(3); // 1.235e+5
  /// 123.toStringAsExponential(0);    // 1e+2
  /// ```
  String toStringAsExponential([int fractionDigits]) => value.toStringAsExponential();

  
  /// A decimal-point string-representation of this number.
  ///
  /// Converts this number to a [double]
  /// before computing the string representation,
  /// as by [toDouble].
  ///
  /// If the absolute value of `this` is greater then or equal to `10^21` then
  /// this methods returns an exponential representation computed by
  /// `this.toStringAsExponential()`. Otherwise the result
  /// is the closest string representation with exactly [fractionDigits] digits
  /// after the decimal point. If [fractionDigits] equals 0 then the decimal
  /// point is omitted.
  ///
  /// The parameter [fractionDigits] must be an integer satisfying:
  /// `0 <= fractionDigits <= 20`.
  ///
  /// Examples:
  /// ```dart
  /// 1.toStringAsFixed(3);  // 1.000
  /// (4321.12345678).toStringAsFixed(3);  // 4321.123
  /// (4321.12345678).toStringAsFixed(5);  // 4321.12346
  /// 123456789012345.toStringAsFixed(3);  // 123456789012345.000
  /// 10000000000000000.toStringAsFixed(4); // 10000000000000000.0000
  /// 5.25.toStringAsFixed(0); // 5
  /// ```
  String toStringAsFixed(int fractionDigits) => value.toStringAsFixed(fractionDigits);

  /// This number as a [double].
  ///
  /// If an integer number is not precisely representable as a [double],
  /// an approximation is returned.
  double toDouble() => value.toDouble();

  
  /// Truncates this [num] to an integer and returns the result as an [int].
  ///
  /// Equivalent to [truncate].
  int toInt() => value.toInt();

  
  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit].
  ///
  /// The comparison is done using [compareTo] and therefore takes `-0.0` into
  /// account. This also implies that [double.nan] is treated as the maximal
  /// double value.
  ///
  /// The arguments [lowerLimit] and [upperLimit] must form a valid range where
  /// `lowerLimit.compareTo(upperLimit) <= 0`.
  num clamp(num lowerLimit, num upperLimit) => value.clamp(lowerLimit, upperLimit);


  @override
  ReactiveContext get context => obs.context;

  @override
  get equals => obs.equals;

  @override
  bool get hasObservers => obs.hasObservers;

  @override
  intercept(interceptor) => obs.intercept(interceptor);

  @override
  String get name => obs.name;

  @override
  observe(listener, {bool fireImmediately}) =>
      obs.observe(listener, fireImmediately: fireImmediately);

  @override
  void Function() onBecomeObserved(Function fn) => obs.onBecomeObserved(fn);

  @override
  void Function() onBecomeUnobserved(Function fn) => obs.onBecomeUnobserved(fn);

  @override
  void reportChanged() => obs.reportChanged();

  @override
  void reportObserved() => obs.reportObserved();

  @override
  set value(double value) => obs.value = value;
}
