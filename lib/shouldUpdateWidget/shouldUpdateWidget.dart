import 'package:flutter/material.dart';
// I HAVE NOT TESTED IF THIS WORKS
mixin ShouldUpdate<T extends Widget> on Widget {
  bool shouldUpdateWidget(T oldWidget);

  @override
  // ignore: invalid_override_of_non_virtual_member
  bool operator ==(Object other) {
    return other is Widget && !shouldUpdateWidget(other);
  }
}

class Title extends StatelessWidget with ShouldUpdate<Title> {
  final String hi;

  const Title({Key key, this.hi}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool shouldUpdateWidget(Title oldWidget) {
    return true;
  }
}

class Counter extends StatefulWidget with ShouldUpdate<Counter> {
  final _CounterState state = _CounterState();
  
  @override
  _CounterState createState() => state;

  @override
  bool shouldUpdateWidget(Counter oldWidget) {
    return state.shouldUpdate;
  }
}

class _CounterState extends State<Counter> {
  final shouldUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
