
import 'dart:ui';

import 'package:flutter/widgets.dart';

FunctionWidgetType getType(Function fn) {
  final types = <Function, FunctionWidgetType>{};
  return types[fn] ??= FunctionWidgetType(fn);
}

class FunctionWidgetType extends Type {
  final Function type;
  FunctionWidgetType(this.type);

  @override
  bool operator ==(Object other) {
    return other is FunctionWidgetType && other.type == type;
  }

  @override
  int get hashCode => hashValues(type, this.runtimeType);
}

class FWidget<T> extends Widget {
  const FWidget(this.builder, this.props, {Key key}) : super(key: key);

  final T props;
  final Widget Function(T props) builder;

  @override
  Element createElement() => FElement<T>(this);

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

class FElement<T> extends ComponentElement {
  FElement(FWidget<T> widget) : super(widget);

  @override
  FWidget<T> get widget => super.widget as FWidget<T>;

  @override
  Widget build() {
    FElement.currentElement = this;
    final built = widget.builder(widget.props);
    FElement.currentElement = null;
    return built;
  }

  static FElement currentElement;
}
