import 'package:flutter/material.dart';

extension on List {
  Row asRow() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: this);
  Column asColumn() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: this);
}

extension on Flex {
  Flex mainAxisAlignment(MainAxisAlignment mainAxisAlignment) =>
      Row(children: this.children, mainAxisAlignment: mainAxisAlignment);
  Flex copyWith({
    Key key,
    Axis direction,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline textBaseline,
    List<Widget> children,
  }) {
    return Flex(
        direction: direction ?? this.direction,
        key: key ?? this.key,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        mainAxisSize: mainAxisSize ?? this.mainAxisSize,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
        textDirection: textDirection ?? this.textBaseline,
        verticalDirection: verticalDirection ?? this.verticalDirection,
        textBaseline: textBaseline ?? this.textBaseline,
        children: children ?? this.children);
  }

  Flex $crossAxisAlignment(CrossAxisAlignment crossAxisAlignment) =>
      this.copyWith(crossAxisAlignment: crossAxisAlignment);
  Flex $textDirection(TextDirection textDirection) =>
      this.copyWith(textDirection: textDirection);
  Flex $verticalDirection(VerticalDirection verticalDirection) =>
      this.copyWith(verticalDirection: verticalDirection);
  Flex $textBaseline(TextBaseline textBaseline) =>
      this.copyWith(textBaseline: textBaseline);
  Flex $children(List<Widget> children) => this.copyWith(children: children);
  Flex $mainAxisSize(MainAxisSize mainAxisSize) =>
      this.copyWith(mainAxisSize: mainAxisSize);
  Flex $mainAxisAlignment(MainAxisAlignment mainAxisAlignment) =>
      this.copyWith(mainAxisAlignment: mainAxisAlignment);
}

extension on Text {
  get _textStyle => style == null ? const TextStyle() : style;
  Text $Color(Color color) =>
      Text(data, style: _textStyle.copyWith(color: color));
  Text $fontSize(double size) =>
      Text(data, style: _textStyle.copyWith(fontSize: size));
  Text $fontWeight(FontWeight weight) =>
      Text(data, style: _textStyle.copyWith(fontWeight: weight));
  Text $letterSpacing(double spacing) =>
      Text(data, style: _textStyle.copyWith(letterSpacing: spacing));
}
