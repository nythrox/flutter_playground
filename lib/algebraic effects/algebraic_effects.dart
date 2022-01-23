import 'dart:async';
/* 
algebraic effects would be kinda useless for things like State because you would have to open a handler for each widget
the only effects that would matter the most would be Future (u can do with suspense), local state(hooks), exceptions (think it though!!)
see if you can model exceptions + futures  + streams + (any placeholder/loading) with only suspense/inherited widget (also check fluter notifications   )
see flutter suspense:
https://pub.dev/packages/suspense
*/

DoContext context;

Action<R> Do<R>(R Function() action) {
  final trace = [];
  final ctx = DoContext(trace);
  step() {
    final savedContext = context;
    ctx.pos = 0;
    try {
      context = ctx;
      return Of(action());
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

T perform<T>(Action<T> monad) {
  if (context.pos < context.trace.length) return context.trace[context.pos++];
  throw DoNotationBind(monad);
}

class DoContext {
  List<dynamic> trace;
  int pos;
  DoContext(this.trace);
}

class DoNotationBind<T> {
  final Action<T> monad;

  DoNotationBind(this.monad);
}


abstract class Action<T> {
  const Action(this.type);
  final Type type;
  Action<T2> chain<T2>(Action<T2> chainer(T value)) {
    return Chain(this, chainer);
  }

  Action<T2> map<T2>(T2 mapper(T value)) {
    return Chain(this, (value) => Of(mapper(value)));
  }

}

class Of<T> extends Action<T> {
  const Of(this.value) : super(Of);
  final T value;
}

class Chain<T, T2> extends Action<T2> {
  const Chain(this.after, this.chainer) : super(Chain);

  final Action<T> after;
  final Action<T2> Function(T value) chainer;
}

class Options {
  const Options(this.programCtx);

  final Context programCtx;
}

abstract class Effect<Returns> {
  const Effect();
}

class Perform<R, Eff extends Effect<R>> extends Action<R> {
  const Perform(this.effect, {this.options}) : super(Perform);

  final Options options;
  final Eff effect;
}

// typedef Action<T2> HandlerFN<T2>(dynamic effect, [Context k]);
class HandlerFns<R> {
  const HandlerFns();
}

class handle<E extends Effect<V>, R, V> extends HandlerFns<R> {
  handle(this.handlerFn);
  final Type effect = E;
  final Action<R> Function(
          E effect, Context ctx, Action<R> Function(Context k, V value) resume)
      handlerFn;
}

class Handler<T, T2, Eff> extends Action<T2> {
  Handler(this.program, {this.transform, this.handle}) : super(Handler);
  
  final effType = Eff;
  final Action<T> program;
  final Action<T2> Function(T value) transform;
  final Action<T2> Function(Eff effect, Context ctx) handle;
  // final Set<HandlerFns<T2>> handlers; // resume() will return T // TODO: since you couldn't get the type of Resume anyways, just revert it back to multi handler
}

class Resume<T, A> extends Action<T> {
  const Resume(this.cont, this.value) : super(Resume);

  final Context cont;
  final A value;
}

class SingleCallback<T> extends Action<T> {
  const SingleCallback(this.callback) : super(SingleCallback);

  final void Function(void Function(T value) done) callback;
}

class HandlerNotFoundError extends Error {
  HandlerNotFoundError(this.message, this.key);

  final Type key;
  final String message;
}

class BadResumeError extends Error {
  BadResumeError(this.message);

  final String message;
}

class Context<T> {
  Context({this.action, this.prev, this.transformCtx, this.programCtx});

  Context prev;
  Action<T> action;

  // resume
  Context transformCtx;
  Context programCtx;
}

List<dynamic> findHandlers(
    Type key, Context context, void Function(dynamic) onError) {
  Context curr = context;
  while (curr != null) {
    final action = curr.action;
    if (curr.action is Handler) {
      // final _handler = (action as Handler).handlers.firstWhere(
      //     (e) => e is handle && e.effect == key,
      //     orElse: () => null);
      final _handler = (action as Handler).effType == key ? (action as Handler).handle : null;
      print((action as Handler).effType );
      print(key);
      if (_handler != null) {
        return [_handler, curr.transformCtx];
      }
    }
    curr = curr.prev;
  }
  onError(HandlerNotFoundError("Handler not found: $key", key));
  return null;
}

class Interpreter<T> {
  Context context;
  void Function(dynamic) onError;
  void Function(T) onDone;
  bool isPaused;
  Interpreter(
      {void Function(T) onDone,
      void Function(dynamic) onError,
      Context context}) {
    this.context = context;
    this.onError = onError;
    this.onDone = onDone;
    this.isPaused = true;
  }
  run() {
    isPaused = false;
    while (context != null) {
      final action = this.context.action;
      final context = this.context;
      // console.log(context, context.action);
      switch (action.type) {
        case Chain:
          {
            this.context = Context(
              prev: context,
              action: (action as Chain).after,
            );
            break;
          }
        case Of:
          {
            this.returnToPrevious((action as Of).value, context);
            break;
          }
        case SingleCallback:
          {
            this.context = null;
            (action as SingleCallback).callback((value) {
              this.returnToPrevious(value, context);
              if (this.isPaused) {
                this.run();
              }
            });
            break;
          }
        case Handler:
          {
            final program = (action as Handler).program;
            final transformCtx = Context(
              prev: context,
              action: program,
            );
            final lastPrev = context.prev;
            final returnHandler = (action as Handler).transform;
            context.prev = Context(
              prev: lastPrev,
              action: returnHandler != null
                  ? program.chain(returnHandler)
                  : program.chain((value) => Of(value)),
            );
            context.transformCtx = context.prev;
            this.context = transformCtx;
            break;
          }
        case Perform:
          {
            final options = (action as Perform).options;
            final effect = (action as Perform).effect;
            final h = findHandlers(effect.runtimeType,
                options?.programCtx ?? context, this.onError);
            if (h == null) return;
            final handler = h[0];
            final transformCtx = h[1] as Context;
            final handlerAction = handler(
                effect,
                Context(
                  transformCtx: transformCtx,
                  programCtx: context,
                ));
            final activatedHandlerCtx = Context(
              // 1. Make the activated handler returns to the *return transformation* parent,
              // and not to the *return transformation* directly (so it doesn't get transformed)
              prev: transformCtx.prev,
              action: handlerAction,
            );
            this.context = activatedHandlerCtx;
            break;
          }
        case Resume:
          {
            // inside activatedHandlerCtx
            final value = (action as Resume).value;
            final cont = (action as Resume).cont;
            // context of the transformer, context of the program to continue
            if (cont == null ||
                !(cont != null &&
                    cont.transformCtx != null &&
                    cont.programCtx != null)) {
              this.onError(
                  BadResumeError("Missing continuation parameter in resume"));
              return;
            }
            final transformCtx = cont.transformCtx;
            final programCtx = cont.programCtx;
            // 3. after the transformation is done, return to the person chaining `resume`
            // /\ when the person chaining resume (activatedHandlerCtx) is done, it will return to the transform's parent
            transformCtx.prev = context.prev;
            // 2. continue the main program with resumeValue,
            // and when it finishes, let it go all the way through the *return* transformation proccess
            // /\ it goes all the way beacue it goes to programCtx.prev (before perform) that will eventually fall to transformCtx
            this.returnToPrevious(value, programCtx);
            break;
          }
        default:
          {
            this.onError(Exception("Invalid instruction: $action"));
            return;
          }
      }
    }
    this.isPaused = true;
  }

  returnToPrevious(value, Context currCtx) {
    final prev = currCtx?.prev;
    if (prev != null) {
      switch (prev.action.type) {
        case Handler:
          {
            this.returnToPrevious(value, prev);
            break;
          }
        case Chain:
          {
            this.context = Context(
                prev: prev.prev, action: (prev.action as Chain).chainer(value));
            break;
          }
        default:
          {
            this.onError(new Exception("Invalid state"));
          }
      }
    } else {
      this.onDone(value);
      this.context = null;
    }
  }
}

class Io<T> extends Effect<T> {
  final T Function() thunk;
  Io(this.thunk);
}
// Action<T2> Function<T>(Action<T> program) handler<T2>(Map<Type, HandlerFN<T2>> handlers) {
//   return <T>(Action<T> program) {
//     return Handler<T,T2>(handlers, program);
//   };
// }
// final withIo = handler({
//   // Return: (value) => Of(() => value),
//   Io: (Io<dynamic> thunk, k) => Resume(k, thunk()),
// });

Action<T Function()> withIo<T, V>(Action<T> program) {
  return Handler(
    program,
    transform: (value) => Of(() => value),
    handle: (Io<V> io, k) => Resume(k, io.thunk()),
    //   handlers: {
    //   handle(),
    // }
  );
}

// const Effect = {
//   map,
//   chain,
//   of: pure,
//   single: makeGeneratorDo(pure)(chain),
//   do: makeMultishotGeneratorDo(pure)(chain),
// };
// const eff = Effect.single;
// const forEach = effect("forEach");

// const withForEach = handle({
//   return: (val) => pure([val]),
//   forEach: (array, k) => {
//     const nextInstr = (newArr = []) => {
//       if (array.length === 0) {
//         return pure(newArr);
//       } else {
//         const first = array.shift();
//         return resume(k, first).chain((a) => {
//           for (const item of a) {
//             newArr.push(item);
//           }
//           return nextInstr(newArr);
//         });
//       }
//     };
//     return nextInstr();
//   },
// });

// const raise = effect("error");
// const handleError = (handleError) =>
//   handle({
//     error: (exn, k) => handleError(k, exn),
//   });
// const toEither = handle({
//   return: (value) =>
//     pure({
//       type: "right",
//       value,
//     }),
//   error: (exn) =>
//     pure({
//       type: "left",
//       value: exn,
//     }),
// });
// const waitFor = effect("async");

// const withIoPromise = handle({
//   return: (value) => pure(Promise.resolve(value)),
//   async: (iopromise, k) =>
//     io(iopromise).chain((promise) =>
//       singleCallback((done) => {
//         promise
//           .then((value) => {
//             done({ success: true, value });
//           })
//           .catch((error) => {
//             done({ success: false, error });
//           });
//       }).chain((res) =>
//         res.success
//           ? resume(k, res.value)
//           : options({
//               scope: k,
//             })(raise(res.value)).chain((e) => resume(k, e))
//       )
//     ),
// });
Future<T> run<T>(Action<T> program) {
  final completer = Completer<T>();
  Interpreter<T Function()>(
    onDone: (thunk) {
      // const either = thunk();
      // if (either.type === "right") {
      //   resolve(either.value);
      // } else {
      //   reject(either.value);
      // }
      completer.complete(thunk());
    },
    onError: completer.completeError,
    context: Context<T Function()>(
      // action: pipe(program, withIoPromise, toEither, withIo),
      action: withIo(program),
    ),
  ).run();
  return completer.future;
}



class HelloWorld extends Effect<void> {}

main() async {
  final program = Handler(
      Perform(HelloWorld()),
      handle: (HelloWorld eff, k) => Of("hello world"),
    );
  print(await run(program));
}
