import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// part of "package:flutter/widgets.dart";

  class FWidget<T> extends StatefulWidget {
    @override
    FState<T> createState() => FState<T>();

    const FWidget(this.builder, this.props, {Key key}) : super(key: key);

    final T props;
    final Widget Function(T props, FState<T> state) builder;

    @override
    Type get runtimeType => builder.runtimeType;

    // Why is Widget.operator== marked as non-virtual? #49490 https://github.com/flutter/flutter/issues/49490
    @override
    // ignore: invalid_override_of_non_virtual_member
    bool operator ==(Object other) {
      return other is FWidget<T> && other.key == key && other.props == props;
    }

    @override
    // ignore: invalid_override_of_non_virtual_member
    int get hashCode => hashValues(props, builder, key);
  }

  class FState<T> extends State<FWidget> {
    void Function() onInit;

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
      FState.currentState = this;
      FState.currentContext = context;
      FState.currentSetState = setState;
      final built = widget.builder(widget.props, this);
      FState.currentState = null;
      FState.currentContext = null;
      FState.currentSetState = null;
      return built;
    }

    static FState currentState;
    static BuildContext currentContext;
    static void Function(VoidCallback fn) currentSetState;
  }

final Title = title.widget;
Widget title(String text, FState state) {
  state.onInit = () {
    print("hello world");
  };
  state.onDispose = () {
    print("goodbye world");
  };
  return FlatButton(
    onPressed: () {
      state.setState(() {

      });
    },
    child: Text(text),
  );
}

final tree = Column(
  children: [
    Title("hi"),
    Title("hello"),
    Title("hi"),
  ],
);

const titleConst = FWidget(title, "hi");

// does not become const because dart is stupid
// Widget hello(final String name) {
//   return const FWidget(hello, name);
// }

extension hi<T> on Widget Function(T props, FState state) {
  Widget Function(T props) get widget {
    return (T props, {Key key}) {
      return FWidget<T>(
        this,
        props,
        key: key,
      );
    };
  }
}

BuildContext context;

T autoDispose<T>(T value) {
  return value;
}

class Effect<T> {}
