import 'package:flutter/material.dart';

const dynamic MagicState = const GetName();

class States {
  // static final states = <String, ObservableNode>{};
  static final _states = <String,
      dynamic>{}; //can be ObservableNode, #dispose function, #initState function, #shouldWidgetUpdate
  static Element currentElement;

  static T getState<T>(String name) => _states[name] as T;
  static bool hasState(String name) => _states[name] != null;
  static void setState<T>(String name, T value) => _states[name] = value;
}

class ObserverElement<T> extends StatefulElement {
  bool didUpdate = false;

  ObserverElement(ObserverWidget<T> widget) : super(widget);

  @override
  ObserverWidget<T> get widget => super.widget as ObserverWidget<T>;

  @override
  void unmount() {
    final name = hashCode.toString() + kDisposeName;
    if (States.hasState(name)) {
      States.getState<void Function()>(name)();
    }
    super.unmount();
  } //can be ObservableNode, #dispose function, #initState function, #shouldWidgetUpdate

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    final name = hashCode.toString() + kInitStateName;
    if (States.hasState(name)) {
      States.getState<void Function()>(name)();
    }
  }

  @override
  void update(StatefulWidget newWidget) {
    final name = hashCode.toString() + kDidUpdateWidgetName;
    final oldWidget = widget;
    super.update(newWidget);
    if (States.hasState(name)) {
      States.getState<ObserverDidUpdateWidgetFunction<T>>(name)(oldWidget);
    }
  }

  @override
  Widget build() {
    States.currentElement = this;
    final result = super.build();
    States.currentElement = null;
    didUpdate = true;
    return result;
  }
}

typedef ObserverDidUpdateWidgetFunction<T> = void Function(
    ObserverWidget<T> oldWidget);

const kDisposeName = "#dispose";
const kInitStateName = "#initState";
const kDidUpdateWidgetName = "#didUpdateWidget";

class ObservableNode<T> {
  final Set<Element> observers = {};

  T _value;
  T get value {
    final dependant = States.currentElement;
    print("dependant: $dependant");
    if (dependant != null) {
      observers.add(dependant);
    }
    return _value;
  }

  set value(T value) {
    _value = value;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print("observers: $observers");
    final localObservers = Set.from(observers);
    for (Element observer in localObservers) {
      // if (observer.active) { // TODO: observer.active
        observer.markNeedsBuild();

        print("updating $observer");
      // } else {
      //   observers.remove(observer);
      // }
    }
  }

  void setValue(T Function(T oldValue) action) {
    value = action(_value);
  }

  ObservableNode(this._value);
}

abstract class ObserverWidget<T> extends StatefulWidget {
  /// Initializes [key] for subclasses.
  const ObserverWidget({Key key}) : super(key: key);

  @override
  ObserverElement<T> createElement() => ObserverElement<T>(this);

  @override
  _ObserverWidgetState createState() => _ObserverWidgetState();

  @protected
  Widget build(BuildContext context);
}

class _ObserverWidgetState extends State<ObserverWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}

void observableDispose(void Function() onDispose) {
  final name = States.currentElement.hashCode.toString() + kDisposeName;
  States.setState(name, onDispose);
}

void obserableInitState(void Function() onInitState) {
  final name = States.currentElement.hashCode.toString() + kInitStateName;
  States.setState(name, onInitState);
}

typedef DidUpdateObserverWidgetFunction<WidgetProps> = void Function(
    WidgetProps oldProps);

void observableDidUpdateWidget<WidgetProps>(
    DidUpdateObserverWidgetFunction<WidgetProps> onDidUpdateWidget) {
  final name = States.currentElement.hashCode.toString() + kDidUpdateWidgetName;
  States.setState(name, onDidUpdateWidget);
}

//This is a getter and setter wrapper for a specific Element to be able to use this in callbacks
class Value<T> {
  final Element element;
  final ObservableNode<T> observableValue;
  T _getValue() {
    final oldElement = States.currentElement;
    States.currentElement = element;
    final value = observableValue.value;
    States.currentElement = oldElement;
    return value;
  }

  T call() => _getValue();

  _setValue(T v) {
    final oldElement = States.currentElement;
    States.currentElement = element;
    observableValue.value = v;
    // States.setState(valueName, v);
    States.currentElement = oldElement;
  }

  T get get => _getValue();
  T get value => _getValue();
  T getValue() => _getValue();

  set set(T v) => _setValue(v);
  set value(T v) => _setValue(v);
  setValue(T v) => _setValue(v);
  set get(T v) => _setValue(v);

  T getOrSet([T newValue]) {
    if (newValue != null) {
      _setValue(newValue);
    }
    return _getValue();
  }

  Value(this.element, this.observableValue);
}

extension on Value<List> {
  operator [](int i) => this._getValue()[i]; // get
  operator []=(int i, value) => this._getValue()[i] = value; // set
}

class ObservableInheritedElement<T> extends InheritedElement {
  final T value;
  final void Function() onDispose;
  dispose() {
    this.unmount();
    onDispose();
  }

  ObservableInheritedElement(this.value, this.onDispose) : super(null);
}

Value<T> createLocalState<T>(T value, String observableName) {
  final element = States.currentElement;
  final name = element.hashCode.toString() + observableName;
  if (!States.hasState(name)) {
    States.setState<ObservableNode<T>>(name, new ObservableNode<T>(value));
  }
  return Value<T>(
      States.currentElement, States.getState<ObservableNode<T>>(name));
  // return States.getState<ObservableNode<T>>(name);
}

ObservableInheritedElement createInheritedState<T>(
    T value, String observableName,
    [BuildContext context]) {
  var inheritedElement;
  inheritedElement = new ObservableInheritedElement<T>(value, () {
    inheritedElement = null;
  });
  States.setState(observableName, inheritedElement);
  context.dependOnInheritedElement(inheritedElement);
  return inheritedElement;
}

ObservableInheritedElement getInheritedState<T>(String observableName) {
  States.getState(observableName);
  return States.getState(observableName);
}

Value<T> createGlobalState<T>(T value, String observableName) {
  // final element = ObserverElement.currentElement;
  final name = observableName;
  if (!States.hasState(name)) {
    States.setState<ObservableNode<T>>(name, new ObservableNode<T>(value));
  }
  return Value<T>(
      States.currentElement, States.getState<ObservableNode<T>>(name));
  // return States.getState<ObservableNode<T>>(name);
}

Value<T> getGlobalState<T>(String observableName) {
  final name = observableName;
  // if (!States.hasState(name)) {
  //   throw new Exception("No observable with this name");
  // }
  return Value<T>(
      States.currentElement, States.getState<ObservableNode<T>>(name));
  // return States.getState<ObservableNode<T>>(name);
}

class GetName {
  const GetName();

  @override
  String noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      return invocation.memberName.name;
    }
    throw Exception("Please do not use this as a getter or a function.");
  }
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

Value<T> getProvider<T>() {
  final provider =
      States.currentElement.findAncestorWidgetOfExactType<Provider<T>>();
  if (provider == null) {
    throw new Exception("No ancestor provider found for $T");
  }
  return Value<T>(States.currentElement, provider.value);
}

//The only thing a provider does is exist with value -> ObservableNode
//and the getProvider<T>() checks to see if there is a parent that provides T
class Provider<T> extends StatelessWidget {
  final ObservableNode<T> value;
  final Widget child;
  Provider._(this.child, {this.value});

  factory Provider.fromValue({@required T value, @required Widget child}) {
    final name = States.currentElement.hashCode.toString() + "$T";
    if (!States.hasState(name)) {
      States.setState<ObservableNode<T>>(name, ObservableNode<T>(value));
    }
    final v = States.getState<ObservableNode<T>>(name);
    return Provider._(child, value: v);
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class AppStore {
  String user = "jason";
}

Provider<T> Function(Widget child) createProvider<T>([T initialValue]) {
  final name = States.currentElement.hashCode.toString() + "$T";
  return (Widget child) {
    if (!States.hasState(name)) {
      States.setState<ObservableNode<T>>(name, ObservableNode<T>(initialValue));
    }
    final v = States.getState<ObservableNode<T>>(name);
    return Provider._(child, value: v);
  };
}

ObserverBuilder observer(Widget widget) => ObserverBuilder(widget);

class ObserverBuilder extends ObserverWidget {
  final Widget child;

  const ObserverBuilder(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class TestHome extends ObserverWidget {
  @override
  Widget build(BuildContext context) {
    // final AppStoreProvider = createProvider(AppStore());
    // return AppStoreProvider(TestNested());
    return Provider<AppStore>.fromValue(value: AppStore(), child: TestNested());
  }
}

class TestNested extends ObserverWidget {
  @override
  Widget build(BuildContext context) {
    final appStore = getProvider<AppStore>();
    return Text(appStore().user);
  }
}
