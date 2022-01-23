import 'package:flutter_tests_projects/functional+hooks/animation.dart';
import 'package:flutter_tests_projects/functional+hooks/primitive_hooks.dart';
import 'package:flutter/material.dart';
import '../flutterUIstuff.dart';
import 'package:flutter_tests_projects/magicState/magicStateStuff.dart';
import 'package:mobx/mobx.dart';

bool debugHotReloadHooksEnabled = true;

final MyWidget = functionalWidget<String>((context, String title, {key}) {
  return Text(title);
});

Widget Function(T props, {Key key}) functionalWidget<T>(
    Widget value(BuildContext c, T props, {Key key})) {
  final uniqueWidgetIdentifier = UniqueKey();
  return (props, {Key key}) {
    var child = Builder(
      key: uniqueWidgetIdentifier,
      builder: (context) {
        return value(context, props, key: key);
      },
    );
    if (key != null) {
      return KeyedSubtree(
        key: key,
        child: child,
      );
    }
    return child;
  };
}

final ItemList = FunctionalWidget.propless((BuildContext context, {Key key}) {
  final items = getGlobalState<List<String>>(MagicState.items);
  return observer(Column(
    children: [
      if (items.get.length % 2 == 0) HomeWidget("jason"),
      ListView.builder(
          shrinkWrap: true,
          itemCount: items.get.length,
          itemBuilder: (context, i) => Text(items.get[i].toString())),

      // if (counter.value % 2 == 0) HomeWidget(HomeWidgetProps("jason")),
    ],
  ));
});

final HomeWidget =
    propfulFunctionalWidget<String>((context, String name, {key}) {
  final counter = useState(0);
  // final counter = createGlobalState(0, MagicState.counter);
  initState(() {
    print("i init stated");
    print(counter.value);
    // print(counter.get);
  });
  didUpdateWidget<String>((oldWidget) {
    print("i updated lamoxd");
  });
  dispose(() {
    print("i disposed");
  });
  // return Text(counter.get.toString() + name);
  return Row(
    children: [
      Text(counter.value.toString()),
      FlatButton(onPressed: () => counter.value++, child: Text("up vruuum"))
    ],
  );
});

final CounterAndButton = proplessFunctionalWidget((context, {key}) {
  final counter = createGlobalState<int>(0, MagicState.counter);
  return observer(Column(
    children: [
      Text(
        counter.get.toString(),
        style: TextStyle(fontSize: 25),
      ),
      FlatButton(
          onPressed: () {
            counter.get = counter.get + 1;
          },
          child: Text("Click me"))
    ],
  ));
});

extension on Function {
  PropfulWidgetCallback<T> asWidget<T>() {
    assert(this.runtimeType != PropfulWidgetFunction,
        "Function must be a PropfulWidgetFunction with args ({$BuildContext} context, $T props, {$Key key}) and return a $Widget");
    return propfulFunctionalWidget<T>(this as PropfulWidgetFunction<T>);
  }
}

typedef PropfulWidgetFunction<T> = Widget
    Function(BuildContext context, T props, {Key key});

typedef PropfulWidgetCallback<T> = PropsFunctionalWidget<T> Function(T props,
    {Key key});

PropfulWidgetCallback<T> propfulFunctionalWidget<T>(
        PropfulWidgetFunction<T> builder) =>
    (T props, {Key key}) => new PropsFunctionalWidget<T>(
          builder,
          props,
          key: key,
        );

extension on ProplessWidgetFunction {
  ProplessWidgetCallback asWidget() => proplessFunctionalWidget(this);
}

typedef ProplessWidgetFunction = Widget Function(BuildContext context,
    {Key key});

typedef ProplessWidgetCallback = ProplessFunctionalWidget Function({Key key});

ProplessWidgetCallback proplessFunctionalWidget(
        ProplessWidgetFunction builder) =>
    ({Key key}) => new ProplessFunctionalWidget(
          builder,
          key: key,
        );

class FunctionalWidget {
  static PropfulWidgetCallback<T> props<T>(PropfulWidgetFunction<T> builder) =>
      propfulFunctionalWidget<T>(builder);
  static ProplessWidgetCallback propless(ProplessWidgetFunction builder) =>
      proplessFunctionalWidget(builder);
  static Widget Function(T props, {Key key}) stateless<T>(
          Widget value(BuildContext c, T props, {Key key})) =>
      functionalWidget(value);
  static ProplessWidgetCallback empty(Widget Function() builder) =>
      ({Key key}) => ProplessFunctionalWidget(
            (context, {key}) => builder(),
            key: key,
          );
}

ThemeData useTheme() {
  return Theme.of(FunctionElement.currentElement);
}

T useInheritedWidget<T extends InheritedWidget>() {
  return (T as dynamic).of(FunctionElement.currentElement);
}

final MyW = FunctionalWidget.empty(() {
  return Text('" asdasd');
});

class FunctionElement<T> extends StatefulElement {
  FunctionElement(_FunctionalWidget widget) : super(widget);

  //the reason for this currentElement is so we can know what
  //functionalWidget is currently being executed when
  //initState, dispose, etc are called without having to pass
  //the build context
  static FunctionElement currentElement;

  void Function() onDispose;
  void Function() onInitState;
  DidUpdateWidgetFunction<T> onDidUpdateWidget;

  @override
  _FunctionalWidget<T> get widget => super.widget as _FunctionalWidget<T>;

  Iterator<HookState> _currentHook;
  int _hookIndex;
  List<HookState> _hooks;
  bool _didFinishBuildOnce = false;

  bool _debugDidReassemble;
  bool _debugShouldDispose;
  bool _debugIsInitHook;

  @override
  Widget build() {
    _currentHook = _hooks?.iterator;
    // first iterator always has null
    _currentHook?.moveNext();
    _hookIndex = 0;
    assert(() {
      _debugShouldDispose = false;
      _debugIsInitHook = false;
      _debugDidReassemble ??= false;
      return true;
    }());
    FunctionElement.currentElement = this;
    final result = super.build();
    FunctionElement.currentElement = null;
    assert(() {
      if (!debugHotReloadHooksEnabled) return true;
      if (_debugDidReassemble && _hooks != null) {
        for (var i = _hookIndex; i < _hooks.length;) {
          _hooks.removeAt(i).dispose();
        }
      }
      return true;
    }());
    assert(_hookIndex == (_hooks?.length ?? 0), '''
Build for $widget finished with less hooks used than a previous build.
Used $_hookIndex hooks while a previous build had ${_hooks.length}.
This may happen if the call to `Hook.use` is made under some condition.
''');
    assert(() {
      if (!debugHotReloadHooksEnabled) return true;
      _debugDidReassemble = false;
      return true;
    }());
    _didFinishBuildOnce = true;

    return result;
  }

  @visibleForTesting
  List<HookState> get debugHooks => List<HookState>.unmodifiable(_hooks);
  @override
  T dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object aspect}) {
    assert(!_debugIsInitHook);
    return super.dependOnInheritedWidgetOfExactType<T>(aspect: aspect);
  }

  @override
  Element updateChild(Element child, Widget newWidget, dynamic newSlot) {
    if (_hooks != null) {
      for (final hook in _hooks.reversed) {
        try {
          hook.didBuild();
        } catch (exception, stack) {
          FlutterError.reportError(FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'hooks library',
            context: DiagnosticsNode.message(
                'while calling `didBuild` on ${hook.runtimeType}'),
          ));
        }
      }
    }
    return super.updateChild(child, newWidget, newSlot);
  }

  @override
  void unmount() {
    if (onDispose != null) {
      onDispose();
    }
    super.unmount();
    if (_hooks != null) {
      for (final hook in _hooks) {
        try {
          hook.dispose();
        } catch (exception, stack) {
          FlutterError.reportError(FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'hooks library',
            context:
                DiagnosticsNode.message('while disposing ${hook.runtimeType}'),
          ));
        }
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    assert(() {
      _debugDidReassemble = true;
      if (_hooks != null) {
        for (final hook in _hooks) {
          hook.reassemble();
        }
      }
      return true;
    }());
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    if (onInitState != null) {
      onInitState();
    }
  }

  @override
  void update(StatefulWidget newWidget) {
    final oldWidget = widget;
    super.update(newWidget);
    if (onDidUpdateWidget != null) {
      onDidUpdateWidget(oldWidget.props);
    }
  }

  R _use<R>(Hook<R> hook) {
    HookState<R, Hook<R>> hookState;
    // first build
    if (_currentHook == null) {
      assert(_debugDidReassemble || !_didFinishBuildOnce);
      hookState = _createHookState(hook);
      _hooks ??= [];
      _hooks.add(hookState);
    } else {
      // recreate states on hot-reload of the order changed
      assert(() {
        if (!debugHotReloadHooksEnabled) return true;
        if (!_debugDidReassemble) {
          return true;
        }
        if (!_debugShouldDispose &&
            _currentHook.current?.hook?.runtimeType == hook.runtimeType) {
          return true;
        }
        _debugShouldDispose = true;

        // some previous hook has changed of type, so we dispose all the following states
        // _currentHook.current can be null when reassemble is adding new hooks
        if (_currentHook.current != null) {
          _hooks.remove(_currentHook.current..dispose());
          // has to be done after the dispose call
          hookState = _insertHookAt(_hookIndex, hook);
        } else {
          hookState = _pushHook(hook);
        }
        return true;
      }());
      if (!_didFinishBuildOnce && _currentHook.current == null) {
        hookState = _pushHook(hook);
        _currentHook.moveNext();
      } else {
        assert(_currentHook.current != null);
        assert(_debugTypesAreRight(hook));

        if (_currentHook.current.hook == hook) {
          hookState = _currentHook.current as HookState<R, Hook<R>>;
          _currentHook.moveNext();
        } else if (Hook.shouldPreserveState(_currentHook.current.hook, hook)) {
          hookState = _currentHook.current as HookState<R, Hook<R>>;
          _currentHook.moveNext();
          final previousHook = hookState._hook;
          hookState
            .._hook = hook
            ..didUpdateHook(previousHook);
        } else {
          hookState = _replaceHookAt(_hookIndex, hook);
          _resetsIterator(hookState);
          _currentHook.moveNext();
        }
      }
    }
    _hookIndex++;
    return hookState.build(this);
  }

  HookState<R, Hook<R>> _replaceHookAt<R>(int index, Hook<R> hook) {
    _hooks.removeAt(_hookIndex).dispose();
    var hookState = _createHookState(hook);
    _hooks.insert(_hookIndex, hookState);
    return hookState;
  }

  HookState<R, Hook<R>> _insertHookAt<R>(int index, Hook<R> hook) {
    var hookState = _createHookState(hook);
    _hooks.insert(index, hookState);
    _resetsIterator(hookState);
    return hookState;
  }

  HookState<R, Hook<R>> _pushHook<R>(Hook<R> hook) {
    var hookState = _createHookState(hook);
    _hooks.add(hookState);
    _resetsIterator(hookState);
    return hookState;
  }

  bool _debugTypesAreRight(Hook hook) {
    assert(_currentHook.current.hook.runtimeType == hook.runtimeType);
    return true;
  }

  /// we put the iterator on added item
  void _resetsIterator(HookState hookState) {
    _currentHook = _hooks.iterator;
    while (_currentHook.current != hookState) {
      _currentHook.moveNext();
    }
  }

  HookState<R, Hook<R>> _createHookState<R>(Hook<R> hook) {
    assert(() {
      _debugIsInitHook = true;
      return true;
    }());
    final state = hook.createState()
      .._element = this.state
      .._hook = hook
      ..initHook();

    assert(() {
      _debugIsInitHook = false;
      return true;
    }());

    return state;
  }
}

abstract class _FunctionalWidget<T> extends StatefulWidget {
  const _FunctionalWidget({
    Key key,
    this.props,
  }) : super(key: key);
  @override
  _FunctionalWidgetState<T> createState() => _FunctionalWidgetState<T>();

  final T props;

  @override
  FunctionElement<T> createElement() => FunctionElement<T>(this);
}

class _FunctionalWidgetState<T> extends State<PropsFunctionalWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}

class PropsFunctionalWidget<T> extends _FunctionalWidget<T> {
  /// Initializes [key] for subclasses.
  const PropsFunctionalWidget(
    this.builder,
    this.props, {
    Key key,
  }) : super(key: key, props: props);

  final PropfulWidgetFunction builder;

  final T props;

  Widget build(BuildContext context, {Key key}) =>
      builder(context, props, key: key);
}

class ProplessFunctionalWidget extends _FunctionalWidget<Null> {
  /// Initializes [key] for subclasses.
  const ProplessFunctionalWidget(
    this.builder, {
    Key key,
  }) : super(key: key, props: null);

  final ProplessWidgetFunction builder;

  Widget build(BuildContext context, {Key key}) => builder(context, key: key);
}

typedef DidUpdateWidgetFunction<WidgetProps> = void Function(
    WidgetProps oldProps);

void dispose(void Function() onDispose) {
  assert(FunctionElement.currentElement != null,
      "Must use initState inside a FunctionalWidget.");
  FunctionElement.currentElement.onDispose = onDispose;
}

void initState(void Function() onInitState) {
  assert(FunctionElement.currentElement != null,
      "Must use initState inside a FunctionalWidget.");
  FunctionElement.currentElement.onInitState = onInitState;
}

void didUpdateWidget<WidgetProps>(
    DidUpdateWidgetFunction<WidgetProps> onDidUpdateWidget) {
  assert(FunctionElement.currentElement != null,
      "Must use initState inside a FunctionalWidget.");
  (FunctionElement.currentElement as FunctionElement<WidgetProps>)
      .onDidUpdateWidget = onDidUpdateWidget;
}

@immutable
abstract class Hook<R> {
  /// Allows subclasses to have a `const` constructor
  const Hook({this.keys});

  /// Register a [Hook] and returns its value
  ///
  /// [use] must be called withing [HookWidget.build] and
  /// all calls to [use] must be made unconditionally, always
  /// on the same order.
  ///
  /// See [Hook] for more explanations.
  static R use<R>(Hook<R> hook) {
    assert(FunctionElement.currentElement != null, '''
`Hook.use` can only be called from the build method of HookWidget.
Hooks should only be called within the build method of a widget.
Calling them outside of build method leads to an unstable state and is therefore prohibited.
''');
    return FunctionElement.currentElement._use(hook);
  }

  /// A list of objects that specify if a [HookState] should be reused or a new one should be created.
  ///
  /// When a new [Hook] is created, the framework checks if keys matches using [Hook.shouldPreserveState].
  /// If they don't, the previously created [HookState] is disposed, and a new one is created
  /// using [Hook.createState], followed by [HookState.initHook].
  final List<Object> keys;

  /// The algorithm to determine if a [HookState] should be reused or disposed.
  ///
  /// This compares [Hook.keys] to see if they contains any difference.
  /// A state is preserved when:
  ///
  /// - `hook1.keys == hook2.keys` (typically if the list is immutable)
  /// - If there's any difference in the content of [Hook.keys], using `operator==`.
  static bool shouldPreserveState(Hook hook1, Hook hook2) {
    final p1 = hook1.keys;
    final p2 = hook2.keys;

    if (p1 == p2) {
      return true;
    }
    // is one list is null and the other one isn't, or if they have different size
    if ((p1 != p2 && (p1 == null || p2 == null)) || p1.length != p2.length) {
      return false;
    }

    var i1 = p1.iterator;
    var i2 = p2.iterator;
    while (true) {
      if (!i1.moveNext() || !i2.moveNext()) {
        return true;
      }
      if (i1.current != i2.current) {
        return false;
      }
    }
  }

  /// Creates the mutable state for this hook linked to its widget creator.
  ///
  /// Subclasses should override this method to return a newly created instance of their associated State subclass:
  ///
  /// ```
  /// @override
  /// HookState createState() => _MyHookState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of a [HookWidget]. For example,
  /// if the hook is used multiple times, a separate [HookState] must be created for each usage.
  @protected
  HookState<R, Hook<R>> createState();
}

/// The logic and internal state for a [HookWidget]
abstract class HookState<R, T extends Hook<R>> {
  /// Equivalent of [State.context] for [HookState]
  @protected
  BuildContext get context => _element.context;
  State _element;

  /// Equivalent of [State.widget] for [HookState]
  T get hook => _hook;
  T _hook;

  /// Equivalent of [State.initState] for [HookState]
  @protected
  void initHook() {}

  /// Equivalent of [State.dispose] for [HookState]
  @protected
  void dispose() {}

  /// Called synchronously after the [HookWidget.build] method finished
  @protected
  void didBuild() {}

  /// Called everytimes the [HookState] is requested
  ///
  /// [build] is where an [HookState] may use other hooks. This restriction is made to ensure that hooks are unconditionally always requested
  @protected
  R build(BuildContext context);

  /// Equivalent of [State.didUpdateWidget] for [HookState]
  @protected
  void didUpdateHook(T oldHook) {}

  /// {@macro flutter.widgets.reassemble}
  ///
  /// In addition to this method being invoked, it is guaranteed that the
  /// [build] method will be invoked when a reassemble is signaled. Most
  /// widgets therefore do not need to do anything in the [reassemble] method.
  ///
  /// See also:
  ///
  ///  * [State.reassemble]
  void reassemble() {}

  /// Equivalent of [State.setState] for [HookState]
  @protected
  void setState(VoidCallback fn) {
    // ignore: invalid_use_of_protected_member
    _element.setState(fn);
  }
}

BuildContext useContext() {
  assert(FunctionElement.currentElement != null,
      '`useContext` can only be called from the build method of HookWidget');
  return FunctionElement.currentElement;
}

class HookBuilder extends _FunctionalWidget {
  /// The callback used by [HookBuilder] to create a widget.
  ///
  /// If a [Hook] asks for a rebuild, [builder] will be called again.
  /// [builder] must not return `null`.
  final Widget Function(BuildContext context) builder;

  /// Creates a widget that delegates its build to a callback.
  ///
  /// The [builder] argument must not be null.
  const HookBuilder({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  Widget build(BuildContext context) => builder(context);
}
