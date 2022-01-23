main() {
  final value = async(() {
    final num1 = await(Future.value(5));
    final num2 = await(Future.value(2));
    return num1 * num2;
  });
  value.then(print).catchError(print);
  async(() {
    [1, 2, 3, 4, 5].forEach((i) {
      final time = i * 100;
      await(Future.delayed(Duration(milliseconds: time)));
      io(() => print("waiting... $time"));
    });
  });
}

Context context;

Future<T> async<T>(T Function() action) {
  final trace = [];
  final ctx = Context(trace);
  step() {
    final savedContext = context;
    ctx.pos = 0;
    try {
      context = ctx;
      final res = action();
      return Future.value(res);
    } on DoNotationBind catch (bind) {
      final pos = context.pos;
      return (bind.future).then((value) {
        trace.insert(pos, value);
        ctx.pos++;
        return step() as Future<T>;
      });
    } on Io catch (exn) {
      trace.insert(context.pos, exn.action());
      ctx.pos++;
      return step() as Future<T>;
    } finally {
      context = savedContext;
    }
  }

  return step();
}

T await<T>(Future<T> monad) {
  if (context.pos < context.trace.length) return context.trace[context.pos++];
  throw DoNotationBind(monad);
}

T io<T>(T Function() action) {
  if (context.pos < context.trace.length) return context.trace[context.pos++];
  throw Io(action);
}

class Context {
  List<dynamic> trace;
  int pos;
  Context(this.trace);
}

class DoNotationBind<T> {
  final Future<T> future;

  DoNotationBind(this.future);
}

class Io<T> {
  final T Function() action;

  Io(this.action);
}
