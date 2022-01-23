DoContext context;

Monad<R> Do<R>(Monad<T> Function<T>(T value) of, R Function() action) {
  final trace = [];
  final ctx = DoContext(trace);
  step() {
    final savedContext = context;
    ctx.pos = 0;
    try {
      context = ctx;
      return of(action());
    } on DoNotationBind catch (bind) {
      final pos = context.pos;
      return bind.monad.chain((value) {
        trace.insert(pos, value);
        ctx.pos++;
        return step();
      });
    } finally {
      context = savedContext;
    }
  }

  return step();
}

final do_ = Do;

T perform<T>(Monad<T> monad) {
  if (context.pos < context.trace.length) return context.trace[context.pos++];
  throw DoNotationBind(monad);
}

class DoContext {
  List<dynamic> trace;
  int pos;
  DoContext(this.trace);
}

abstract class Monad<T> {
  const Monad();
  Monad<T2> map<T2>(T2 Function(T value) mapper);
  Monad<T2> chain<T2>(Monad<T2> Function(T value) chainer);
}

class DoNotationBind<T> {
  final Monad<T> monad;

  DoNotationBind(this.monad);
}
