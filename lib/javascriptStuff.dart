class gambiarra {
  final List names = [];
  gambiarra(any) {
    names.add(any);
  }
  call(any) {
    names.add(any);
    return this;
  }

  @override
  String toString() {
    return names.join("");
  }
}

jsStuffMain() {
  // Function total = VarArgsFunction<int, int>((args, kwargs) {
  //   return args.reduce((a, b) => a + b);
  // });
  // print(total(1, 2, 3, 4, 5, 6));
  // total(1, 2,
  //     multiply: true,
  //     divide: false); // Got args: [1, 2], kwargs: {x: true, y: false}

  gambiarra(#eu)(#queria)(#estar)(#morto)(#aaa)(#meu)(#deus)(#me)(#mata)(#por)(
      #favor)(#me)(#tira)(#da)(#minha)(#miseria);

  var person = {
    #age: 17,
    #name: "jason",
    #$_$.$_$_$.$_$_$.$_$_$.$_$: "cu",
    #sayHi: () => {}
  }();
  console.log(person.name);
  person.name = "rully";
  console.log(person.name);
  person.lastName = "Alves";
  console.log(person.lastName);
  console.log(person);
  person.sayHi();
}

class JSObject<T> {
  Map<String, T> properties;

  JSObject([properties]) {
    if (properties != null) {
      this.properties = properties;
    }
    properties = <String, T>{};
  }

  T operator [](String name) => properties[name];
  operator []=(String name, T value) => properties[name] = value;

  @override
  noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      properties.containsKey(invocation.memberName.name);
      if (properties.containsKey(invocation.memberName.name)) {
        return properties[invocation.memberName.name];
      }
      return "undefined";
    }
    if (invocation.isSetter) {
      properties[invocation.memberName.name] =
          invocation.positionalArguments.first;
    }
    if (invocation.isMethod) {
      return Function.apply(properties[invocation.memberName.name] as Function,
          invocation.positionalArguments, invocation.namedArguments);
    }
  }

  @override
  toString() {
    return properties.toString();
  }
}

class console {
  static log(Object o) => print(o);
}

extension getName on Symbol {
  String get name => () {
        final getAllWordsRegex = RegExp(r"(?<name>\w*)");
        String text = this.toString().replaceFirst("Symbol", "");
        text = text.replaceAll("(", "");
        text = text.replaceAll(")", "");
        text = text.replaceAll("=", "");
        text = text.replaceAll('"', "");
        text = text.replaceAll('"', "");
        return text;
      }();
}

extension asJSObject on Map<String, Object> {
  call<T>() {
    return JSObject<T>(this);
  }
}

extension asJSObjectSymbo on Map<Symbol, Object> {
  call<T>() {
    return JSObject<T>(this);
  }
}

// typedef VarArgsCallback<R, T> = R Function<R, T>(
//     List<T> args, Map<String, T> kwargs);

// // R = return type, T = params type
// class VarArgsFunction<R, T> implements Function {
//   final VarArgsCallback<R, T> callback;
//   static const int _offset = 'Symbol("'.length;

//   VarArgsFunction(this.callback);

//   // R call() => callback([], {});

//   @override
//   VarArgsCallback<R, T> noSuchMethod(Invocation inv) {
//     return callback(
//       inv.positionalArguments,
//       inv.namedArguments.map(
//         (_k, v) {
//           var k = _k.toString();
//           return MapEntry(k.substring(_offset, k.length - 2), v);
//         },
//       ),
//     );
//   }
// }
