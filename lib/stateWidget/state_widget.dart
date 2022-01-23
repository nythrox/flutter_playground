import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef SetState = void Function(VoidCallback fn);
typedef StatefulWidgetBuilder = Widget Function(
    BuildContext context, SetState setState);

class Stateful extends StatefulWidget {
  final StatefulWidgetBuilder child;
  final Function() onInit;
  final Function() onDispose;
  final Function() onDidUpdate;
  final Function() onReassemble;
  final Function() onDeactivate;
  final Function() onDependenciesChanged;
  const Stateful(
      {Key key,
      this.onInit,
      this.onDispose,
      this.onDidUpdate,
      this.onReassemble,
      this.onDeactivate,
      this.onDependenciesChanged,
      @required this.child})
      : super(key: key);

  @override
  _StatefulState createState() => _StatefulState();
}

class _StatefulState extends State<Stateful> {
  Widget _built;
  @override
  void initState() {
    widget?.onInit();
    super.initState();
  }

  @override
  void dispose() {
    widget?.onDispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Stateful oldWidget) {
    widget?.onDidUpdate();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    widget?.onReassemble();
    super.reassemble();
  }

  @override
  void deactivate() {
    widget?.onDeactivate();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    widget?.onDependenciesChanged();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(context, setState);
  }
}

class Smh extends StatelessWidget {
  int counter;
  @override
  Widget build(BuildContext context) {
    return Stateful(
        onInit: () {
          counter = 0;
        },
        onDispose: () {
          counter = null;
        },
        onDidUpdate: () {
          counter = counter;
        },
        child: (ctx, setState) => RaisedButton(
              onPressed: () => {setState},
              child: Text(counter.toString()),
            ));
  }
}
