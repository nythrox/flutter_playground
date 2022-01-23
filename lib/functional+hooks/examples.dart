import 'package:flutter/material.dart';
import 'package:flutter_tests_projects/functional+hooks/old.dart';
import 'package:flutter_tests_projects/functional+hooks/primitive_hooks.dart';
import 'package:flutter_tests_projects/magicState/magicStateStuff.dart';

final MyWidget = functionalWidget<String>((context, String title, {key}) {
  return Text(title);
});

final ItemList = FunctionalWidget.propless((BuildContext context, {Key key}) {
  final items = getGlobalState<List<String>>(MagicState.items);
  return observer([
    if (items.get.length % 2 == 0) HomeWidget("jason"),
    ListView.builder(
        shrinkWrap: true,
        itemCount: items.get.length,
        itemBuilder: (context, i) => Text(items.get[i].toString())),

    // if (counter.value % 2 == 0) HomeWidget(HomeWidgetProps("jason")),
  ].asColumn());
});

extension on List {
  Row asRow() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: this);
  Column asColumn() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: this);
}

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
  return [
    Text(counter.value.toString()),
    FlatButton(onPressed: () => counter.value++, child: Text("up vruuum"))
  ].asRow();
});

final CounterAndButton = proplessFunctionalWidget((context, {key}) {
  final counter = createGlobalState<int>(0, MagicState.counter);
  return observer([
    Text(
      counter.get.toString(),
      style: TextStyle(fontSize: 25),
    ),
    FlatButton(
        onPressed: () {
          counter.get = counter.get + 1;
        },
        child: Text("Click me"))
  ].asColumn());
});

/*const */
const constHome = ProplessFunctionalWidget(ConstHome);

Widget ConstHome(BuildContext context, {Key key}) {
  return const Text("HAH");
}
