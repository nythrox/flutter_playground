import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_tests_projects/functional+hooks/primitive_hooks.dart';
import 'package:flutter_tests_projects/fwidgets/functional.dart';
import 'package:flutter_tests_projects/no%20boilerplate%20mobx/immutability.dart';
import 'package:flutter_tests_projects/no%20boilerplate%20mobx/mobx.dart';
import 'package:mobx/mobx.dart';
//TODO: function + observable widget
// when you see a thing was observed, you can do :
// - Element.markNeedsBuild() directly on the element, or get the latest (functional observable) Context and mark it as watched (inneficient)
// or
// - check if its an ObservableFunctionalElement, and mark it as observed. If it isn't, warn the user to wrap it around a Observer(() => widget)

final MobxHomepage = _mobxHomepage.widget;

Widget _mobxHomepage(void props) {
  final counter = useState(Counter()).value;
  final user = User()..name = "hi";
  final user2 = copy(user
    ..name = "ugh"
    ..name = "fine");
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      body: Center(
        child: Observer(
          builder: (context) => Text("owo ${counter.count}"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("hi"),
        onPressed: counter.increment,
      ),
    ),
  );
}

abstract class _Counter {
  int count;
  void Function() increment;
}

class Counter extends URFStore implements _Counter {
  Counter() {
    count = 0;
    increment = () => count++;
  }
}

abstract class _User {
  String name;
}

class User extends Immutable<User> implements _User {}
