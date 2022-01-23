import 'do.dart';

class Either<L, R> implements Monad<R> {
  final R value;
  final L error;
  final bool isRight;
  final bool isLeft;

  const Either._(this.value, this.error, this.isRight, this.isLeft);

  static Either<L, R> _left<L, R>(L error) {
    return Either<L, R>._(null, error, false, true);
  }

  static Either<L, R> _right<L, R>(R value) {
    return Either<L, R>._(value, null, true, false);
  }

  static const Left = Either._left;
  static const Right = Either._right;

  @override
  Either<L, R2> chain<R2>(Function(R value) chainer) {
    return isRight ? chainer(value) : this;
  }

  @override
  Either<L, R2> map<R2>(R2 Function(R value) mapper) {
    return isRight ? Either.Right(mapper(value)) : this;
  }

  static Either<L, R> Do<L, R>(R Function() action) {
    return do_(<T>(value) => Right(value), action);
  }
}

const Right = Either.Right;
const Left = Either.Left;

main() {
  final result = Either.Do(() {
    final num1 = perform(Right(5));
    final num2 = perform(Right(2));
    return num1 * num2;
  });
  print(result.value); // 10
}
