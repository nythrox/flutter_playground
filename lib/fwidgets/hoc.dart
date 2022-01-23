import 'package:flutter/material.dart';

// problem with this: no way to know when to reload the widget bcs props arent being passed
// so the widget will always relaod

class TitleState {
  final String name;

  TitleState({this.name});
}

Widget counter({String name}) {
  build() {
    final counter = useState(0, #counter);
    initState(() {});
    dispose(() {});
    return Scaffold(
      body: Column(
        children: [
          Text("Hello world, $name"),
          FlatButton(
            child: Text("$counter"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  return FWidget(build);
}

class S<T> {
  final bool didInit;
  T value;
  final T initialValue;

  S(this.didInit, this.value, this.initialValue);
}

T useState<T>(T initialValue, dynamic key) {
  final S<T> state = currentState.map[key] ??= S(false, null, initialValue);
  if (!state.didInit) {
    state.value = initialValue;
  }
  return state.value;
}

void initState(VoidCallback fn) {
  currentState.onInit ??= fn;
}

void setState(VoidCallback fn) {
  currentState.setState(fn);
}

void dispose(VoidCallback fn) {
  currentState.onDispose ??= fn;
}

class FWidget<T> extends StatefulWidget {
  @override
  FState<T> createState() => FState<T>();

  const FWidget(this.builder, {this.reload, Key key}) : super(key: key);

  final List<dynamic> reload;

  final Widget Function() builder;

  @override
  Type get runtimeType => builder.runtimeType;
}

class FState<T> extends State<FWidget> {
  void Function() onInit;
  Map<dynamic, dynamic> map = {};

  @override
  void initState() {
    super.initState();
    onInit?.call();
  }

  void Function() onDependenciesChanged;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onDependenciesChanged?.call();
  }

  void Function(FWidget widget) onWidgetUpdated;
  @override
  void didUpdateWidget(covariant FWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    onWidgetUpdated?.call(oldWidget);
  }

  void Function() onReassemble;
  @override
  void reassemble() {
    super.reassemble();
    onReassemble?.call();
  }

  void Function() onDeactivate;
  @override
  void deactivate() {
    super.deactivate();
    onDeactivate?.call();
  }

  void Function() onDispose;
  @override
  void dispose() {
    super.dispose();
    onDispose?.call();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(context) {
    currentState = this;
    currentContext = context;
    currentSetState = setState;
    final built = this.widget.builder();
    currentState = null;
    currentContext = null;
    currentSetState = null;
    return built;
  }
}

FState currentState;
BuildContext currentContext;
void Function(VoidCallback fn) currentSetState;
