import 'do.dart';

class Option<T> implements Monad<T> {
  final T value;
  final bool isSome;

  const Option._(this.value, this.isSome);

  static Option<T> _some<T>(T value) {
    return Option<T>._(value, true);
  }

  static Option<T> _none<T>() {
    return Option<T>._(null, false);
  }

  static const Some = Option._some;
  static const None = Option._none;

  @override
  Option<T2> chain<T2>(Function(T value) chainer) {
    return this.isSome ? chainer(value) : this;
  }

  @override
  Option<T2> map<T2>(T2 Function(T value) mapper) {
    return this.isSome ? Some(mapper(value)) : this;
  }

  static Option<T> Do<T>(T Function() action) {
    return do_(Some, action);
  }
}

const Some = Option.Some;
const None = Option.None;

main() {
  final result = Option.Do(() {
    final num1 = perform(Some(5));
    final num2 = perform(Some(2));
    return num1 * num2;
  });
  print(result.value); // 10
}
