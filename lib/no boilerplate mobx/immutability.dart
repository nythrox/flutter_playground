class Change {
  final dynamic key;
  final dynamic value;

  const Change(this.key, this.value);
}

final instanciations = <Type, dynamic Function()>{};
void setupImmutable<T>(T Function() setup) {
  instanciations[T] = setup;
}

T instanciate<T>(Type type) {
  return instanciations[type]!();
}

class Immutable<T extends Immutable<dynamic>> {
  Map<String, dynamic> _values = {};
  List<Change> _changes = [];

  @override
  noSuchMethod(Invocation invocation) {
    print(invocation.runtimeType);
    print(invocation.memberName);
    final name = getName(invocation.memberName);
    if (invocation.isGetter) {
      return _values[name];
    }
    if (invocation.isSetter) {
      _changes.add(Change(name, invocation.positionalArguments.first));
      return;
    }
    if (invocation.isMethod) {
      return Function.apply(
        _values[name],
        invocation.positionalArguments,
        invocation.namedArguments,
      );
    }
  }
  // Computed<String> _$itemsFooterComputed;

  // @override
  // String get itemsFooter =>
  //     (_$itemsFooterComputed ??= Computed<String>(() => super.itemsFooter))
  //         .value;

//   T call(T user);
//   @override
//   bool operator ==(Object other) {
//     if (other is Immutable<T>) {
//       return DeepCollectionEquality().equals(_values, other._values);
//     }
//     return false;
//   }

  T? merge(T other) {}

  T copyChangesTo(T instance) {
    instance._values = {..._values};
    _changes.forEach((change) {
      instance._values[change.key] = change.value;
    });
    return instance;
  }

  T copy<T extends Immutable>(T changed) {
    return copyChangesTo(changed as dynamic) as dynamic;
  }

  T copyFrom<T extends Immutable>(T changed) {
    return changed.copy(this) as dynamic;
  }

  // T copyWith(void Function(T value) builder) {}

//   @override
//   int get hashCode => DeepCollectionEquality().hash(_values);
}

T create<T extends Immutable>(T value) {
  return value.copyChangesTo(value);
}

T copy<T extends Immutable>(T from) {
  final newInstance = instanciate(T);
  return newInstance.copyFrom(from);
}

// have user instance, and create al instances based off that one
// mixin User implements Immutable<User>, _User {}
final _create = create;

// create safely
// final user0 = User.create("jason", 10);
abstract class _User {
  String name;
  int age;
  User child;
}

class User extends Immutable<User> implements _User {}
// final user3 = createWith((User user) => user
//   ..name = "hi"
//   ..age = 200);

// also copy
// final user4 = user3.copyWith((owo) => owo.name = "owo3");

// final user5 = user4(user4..name = "owo");

// this doesnt work because you cannot override it to add a new value (new immutable instance)
// final user5 = user4..name = "user5";

// T createWith<T extends Immutable>(T Function(T user) creator) {}

// TODO:built_value features (auto create object when doing ..user..child..name = "")

main() {
  setupImmutable(() => User());

  final user1 = create(User()
    ..name = "uwu"
    ..age = 100);

// final user2 = user1.copy(User()..name = "owo");
  final user2 = copy(user1
    ..name = "owo"
    ..child = User());

  user2.child.name = "hi";
// final user3 = User().copyFrom(user2..name = "ewe");

  print(user2._values);
//   print(user3._values);
}

String getName(Symbol s) {
  String text = s.toString().replaceFirst("Symbol", "");
  text = text.replaceAll("(", "");
  text = text.replaceAll(")", "");
  text = text.replaceAll("=", "");
  text = text.replaceAll('"', "");
  text = text.replaceAll('"', "");
  return text;
}
