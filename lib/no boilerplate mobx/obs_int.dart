import 'package:mobx/mobx.dart';

class ObservableInt implements Observable<int> {
  final Observable<int> obs;
  int get value => obs.value;
  ObservableInt(int initialValue,
      {String name, ReactiveContext context, bool Function(int, int) equals})
      : obs = Observable(initialValue,
            name: name, context: context, equals: equals);



  /// Returns a string representation of this integer.
  ///
  /// The returned string is parsable by [parse].
  /// For any `int` `i`, it is guaranteed that
  /// `i == int.parse(i.toString())`.
  @override
  String toString() => value.toString();


  /// Bit-wise and operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with only the bits set that are set in
  /// both `this` and [other]
  ///
  /// If both operands are negative, the result is negative, otherwise
  /// the result is non-negative.
  int operator &(int other) => value & other;

  /// Bit-wise or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in either
  /// of `this` and [other]
  ///
  /// If both operands are non-negative, the result is non-negative,
  /// otherwise the result is negative.
  int operator |(int other) => value | other;

  /// Bit-wise exclusive-or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in one,
  /// but not both, of `this` and [other]
  ///
  /// If the operands have the same sign, the result is non-negative,
  /// otherwise the result is negative.
  int operator ^(int other) => value ^ other;

  /// The bit-wise negate operator.
  ///
  /// Treating `this` as a sufficiently large two's component integer,
  /// the result is a number with the opposite bits set.
  ///
  /// This maps any integer `x` to `-x - 1`.
  int operator ~() => ~value;

  /// Shift the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying
  /// the number by `pow(2, shiftIndex)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to
  /// limit intermediate values by using the "and" operator with a suitable
  /// mask.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator <<(int shiftAmount) => value << shiftAmount;

  /// Shift the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  ///`pow(2, shiftIndex)`.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator >>(int shiftAmount) => value >> shiftAmount;

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  int modPow(int exponent, int modulus) => value.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  int modInverse(int modulus) => value.modInverse(modulus);

  /// Returns the greatest common divisor of this integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is  always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  int gcd(int other) => value.gcd(other);

  /// Returns true if and only if this integer is even.
  bool get isEven => value.isEven;

  /// Returns true if and only if this integer is odd.
  bool get isOdd => value.isOdd;

  /// Returns the minimum number of bits required to store this integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values.  Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  /// ```
  /// x.bitLength == (-x-1).bitLength
  ///
  /// 3.bitLength == 2;     // 00000011
  /// 2.bitLength == 2;     // 00000010
  /// 1.bitLength == 1;     // 00000001
  /// 0.bitLength == 0;     // 00000000
  /// (-1).bitLength == 0;  // 11111111
  /// (-2).bitLength == 1;  // 11111110
  /// (-3).bitLength == 2;  // 11111101
  /// (-4).bitLength == 2;  // 11111100
  /// ```
  int get bitLength => value.bitLength;

  /// Returns the least significant [width] bits of this integer as a
  /// non-negative number (i.e. unsigned representation).  The returned value has
  /// zeros in all bit positions higher than [width].
  /// ```
  /// (-1).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit quantity:
  /// ```
  /// q = (q + 1).toUnsigned(8);
  /// ```
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input.  The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  /// ```
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  int toUnsigned(int width) => value.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign.  This is the same as truncating the value
  /// to fit in [width] bits using an signed 2-s complement representation.  The
  /// returned value has the same bit value in all positions higher than [width].
  ///
  /// ```
  ///                                V--sign bit-V
  /// 16.toSigned(5) == -16   //  00010000 -> 11110000
  /// 239.toSigned(5) == 15   //  11101111 -> 00001111
  ///                                ^           ^
  /// ```
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit signed quantity:
  /// ```
  /// q = (q + 1).toSigned(8);
  /// ```
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input.  The minimum width needed to avoid truncation of `x`
  /// is `x.bitLength + 1`, i.e.
  /// ```
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  int toSigned(int width) => value.toSigned(width);

  /// Return the negative value of this integer.
  ///
  /// The result of negating an integer always has the opposite sign, except
  /// for zero, which is its own negation.
  int operator -() => -value;

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  int abs() => value.abs();

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int get sign => value.sign;

  /// Returns `this`.
  int round() => value.round();

  /// Returns `this`.
  int floor() => value.floor();

  /// Returns `this`.
  int ceil() => value.ceil();

  /// Returns `this`.
  int truncate() => value.truncate();

  /// Returns `this.toDouble()`.
  double roundToDouble() => value.roundToDouble();

  /// Returns `this.toDouble()`.
  double floorToDouble() => value.floorToDouble();

  /// Returns `this.toDouble()`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns `this.toDouble()`.
  double truncateToDouble() => value.truncateToDouble();

  /// Converts [this] to a string representation in the given [radix].
  ///
  /// In the string representation, lower-case letters are used for digits above
  /// '9', with 'a' being 10 an 'z' being 35.
  ///
  /// The [radix] argument must be an integer in the range 2 to 36.
  String toRadixString(int radix) => value.toRadixString(radix);


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
  set value(int value) => obs.value = value;
}
