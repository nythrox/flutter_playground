import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

abstract class MatchingActions<T, R> {}

class Otherwise<T, R> with MatchingActions<T, R> {
  final R Function() onMatched;
  Otherwise(this.onMatched);
}

class On<T, R> with MatchingActions<T, R> {
  final R Function(T type) onMatched;
  Type matchesType;
  T imhere;
  On(this.onMatched) : matchesType = T;
}

class OnValue<T, R> with MatchingActions<T, R> {
  final R Function() onMatched;
  final T value;
  OnValue(this.value, this.onMatched);
}

class Matches<T, R> with MatchingActions<T, R> {
  final R Function() onMatched;
  final bool Function() predicate;
  Matches(this.predicate, this.onMatched);
}

MatchingActions<T, R> on<T, R>(R Function(T type) onMatched) {
  return On<T, R>(onMatched);
}

MatchingActions<T, R> equals<T, R>(T value, R Function() onMatched) {
  return OnValue<T, R>(value, onMatched);
}

// MatchingActions<T, R> when<T, R>(
//     Function(T value) predicate, R Function() onMatched) {
//   return Matches<T, R>(predicate, onMatched);
// }

MatchingActions<Null, R> otherwise<R>(R Function() onMatched) {
  return Otherwise<Null, R>(onMatched);
}

// R match<T, R>(T value, Set<MatchingActions<U, R>> matchers) { // only works with on
R match<T, R, U extends T>(T value, Set<MatchingActions<T, R>> matchers) {
  Otherwise _otherwise;
  for (final matcher in matchers) {
    if (matcher is On && value.runtimeType == (matcher as On).matchesType) {
      return (matcher as On).onMatched(value);
    }
    if (matcher is OnValue && (matcher as OnValue).value == value) {
      return (matcher as OnValue).onMatched();
    }
    if (matcher is Matches && (matcher as Matches).predicate(value)) {
      return (matcher as Matches).onMatched();
    }
  }
  return _otherwise?.onMatched();
}

abstract class Greeting {}

class Hi implements Greeting {
  String name;
}

class Bye implements Greeting {
  DateTime seeYouAgain;
}

class When {
  When();

  MatchingActions<T, R> itEquals<T, R>(T value, R Function() onMatched) {
    return OnValue<T, R>(value, onMatched);
  }

  MatchingActions<T, R> itIs<T, R>(R Function(T type) onMatched) {
    return On<T, R>(onMatched);
  }

  MatchingActions<T, R> itMatches<T, R>(
      Function(T value) predicate, R Function() onMatched) {
    return Matches<T, R>(predicate, onMatched);
  }

  MatchingActions<T, R> call<T, R>(
      Function() predicate, R Function() onMatched) {
    return Matches<T, R>(predicate, onMatched);
  }
}

final when = When();

void main() {
  Greeting message = Hi();

  final result = match(message, {
    on((Hi hi) {
      return "hello, ${hi.name}";
    }),
    on((Bye bye) {
      return "bye, see you at ${bye.seeYouAgain}";
    }),
    equals(10, () {
      return "this wil never happen";
    }),
    when(() => message is Greeting, () {
      return "this would happen if it was placed earlier";
    }),
    // with data classes
    // matches(Greeting(name: "hi"), () {

    // }),
    otherwise(() {
      throw Error();
    }),
  });

  print(result);
}

void main2() {
  final future = ObservableFuture.value(10);

  final futureResult = match(future.status, {
    equals(FutureStatus.fulfilled, () {
      return Text("done ${future.value}");
    }),
    equals(FutureStatus.pending, () {
      return CircularProgressIndicator();
    }),
    equals(FutureStatus.rejected, () {
      return Text("error ${future.error}");
    }),
  });

  runApp(futureResult);
}

final fizzBuzz = (int i) => match(i, {
  when(() => i % 3 == 0, () => "Fizz"),
  when(() => i % 5 == 0, () => "Buzz"),
  when(() => i % 3 * 5 == 0, () => "FizzBuzz"),
  otherwise(() => "$i")
});



/*
  when(value, {
    is((Hi hi) {}),
    equals(10, () {}),
    matches((e) => e.isActive, () {}),
    otherwise(() {})
  })

*/
