import 'package:flutter/cupertino.dart';
import 'package:flutter_tests_projects/javascriptStuff.dart';
import 'package:mobx/mobx.dart';

class URFStore {
  Map<String, dynamic> _values = {};
  Map<String, dynamic> _atoms = {};

  @override
  noSuchMethod(Invocation invocation) {
    print(invocation.isAccessor);
    final name = getName(invocation.memberName);
    if (invocation.isGetter) {
      // return get(name);
    }
    if (invocation.isSetter) {
      return set(name, invocation.positionalArguments.first);
    }
    if (invocation.isMethod) {
      return call(
          name, invocation.positionalArguments, invocation.namedArguments);
    }
  }
  // Computed<String> _$itemsFooterComputed;

  // @override
  // String get itemsFooter =>
  //     (_$itemsFooterComputed ??= Computed<String>(() => super.itemsFooter))
  //         .value;


  get value(String name) {
    final Atom atom = _atoms[name] ??= Atom();
    atom.context.enforceReadPolicy(atom);
    atom.reportObserved();
    return _values[name];
  }

  set(String name, value) {
    final Atom atom = _atoms[name] ??= Atom();
    atom.context.conditionallyRunInAction(() {
      _values[name] = value;
      atom.reportChanged();
    }, atom);
  }

  call(String name, List args, Map namedArgs) {
    final ActionController atom = _atoms[name] ??= ActionController();
    final _$actionInfo = atom.startAction();
    try {
      return Function.apply(
        _values[name],
        args,
        // namedArgs,
      );
    } finally {
      atom.endAction(_$actionInfo);
    }
  }
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


