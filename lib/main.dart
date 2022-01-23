import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_tests_projects/javascriptStuff.dart';
import 'package:flutter_tests_projects/no%20boilerplate%20mobx/mobx_homepage.dart';
import 'package:flutter_tests_projects/observableFuture.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'flutterUIstuff.dart';

import 'functional+hooks/functionalWidgetStuff.dart';
import 'magicState/magicStateStuff.dart';

void main() {
  // jsStuffMain();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MobxHomepage(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// class Home extends ObservableWidget {
//   @override
//   Widget build(BuildContext context) {
//     final counter = createGlobalState(0, MagicState.counter);
//     return [
//       Text(counter.value.toString()),
//       Text((counter.value + 2).toString()),
//       FlatButton(
//           onPressed: () {
//             counter.value++;
//           },
//           child: Text("Click me"))
//     ].asColumn();
//   }
// }
// class AccessHome extends ObservableWidget {
//   @override
//   Widget build(BuildContext context) {
//     final counter = getGlobalState<int>(MagicState.counter);
//     return [
//       Text(counter.value.toString()),
//       FlatButton(
//           onPressed: () {
//             counter.value++;
//           },
//           child: Text("Click me")),
//       HomeWidget(HomeWidgetProps("jason"))
//       // if (counter.value % 2 == 0) HomeWidget(HomeWidgetProps("jason")),
//     ].asColumn();
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SeiLa extends StatefulWidget {
  @override
  _SeiLaState createState() => _SeiLaState();
}

const SEILA = "seila";

class _SeiLaState extends State<SeiLa> {
  ObservableInheritedElement disposeInherited;
  @override
  Widget build(BuildContext context) {
    disposeInherited = createInheritedState(0, SEILA, context);
    return Container();
  }

  @override
  void dispose() {
    disposeInherited.dispose();
    super.dispose();
  }
}

class WidgetSeia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedValue = getInheritedState(SEILA);
    return Container();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    final count = getGlobalState<int>(MagicState.counter);
    count.setValue(count.get + 1);
    final items = getGlobalState<List<String>>(MagicState.items);
    items.set = List.from([...items.get, "${count.get}"]);
    // items.get = List.from([...items.get, "${count.get}"]);
  }

  @override
  Widget build(BuildContext context) {
    createGlobalState<List<String>>([], MagicState.items);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: [
        TestHome(),
        // ApiCall(),
        // HomeWidget("jason"),
        // CounterAndButton(),
        // ItemList(),
      ].asColumn(),
      // body: Center(
      //   child: ListView(
      //     children: <Widget>[
      //       Home(),
      //       // Container(
      //       //   child: [
      //       //     Text("HI"),
      //       //     SizedBox(
      //       //       width: 20,
      //       //     ),
      //       //     const Text("Jason")
      //       //         .$fontWeight(FontWeight.bold)
      //       //         .$fontSize(30)
      //       //         .$letterSpacing(10)
      //       //   ]
      //       //       .asRow()
      //       //       .$mainAxisAlignment(MainAxisAlignment.center)
      //       //       .$crossAxisAlignment(CrossAxisAlignment.end),
      //       // ),

      //       // (() => Text(_cartState.counter.toString()))
      //       //     .asObserver()

      //       // observer(() => Text(_cartState.counter.toString())),

      //       // $(() => Text(_cartState.counter.toString())),

      //       // (() => [
      //       //       Text(_cartState.counter.toString())
      //       //           .$fontSize(_cartState.counter * 5.0),
      //       //       Text(_cartState.counter.toString()),
      //       //       Text(_cartState.counter.toString())
      //       //     ].asRow()).asObserver()
      //       // Text(_cartState.counter.toString()).asObservable(),
      //       // Observer(builder: (context) => Text(_cartState.counter.toString())),
      //       // ...generateWidgets(_cartState.numItems),
      //     ],
      //   ),
      // )
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> generateWidgets(int number) {
    List<Widget> list = [];
    for (int i = 0; i < number; i++) {
      list.add(new TestWidget(
        i: i,
        name: "asdasdsad",
      ));
    }
    return list;
  }
}

extension on ChangeNotifier {
  mobx.Observable asObservable() {
    final o = mobx.Observable(0);
    this.addListener(() {
      o.reportChanged();
    });
    return o;
  }
}

typedef WidgetFunction = Widget Function();

extension on WidgetFunction {
  Observer asObserver() => Observer(builder: (context) => this());
}

Observer observer(WidgetFunction w) => Observer(builder: (context) => w());

class $ extends StatelessWidget {
  final WidgetFunction lazyWidget;

  const $(this.lazyWidget, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => lazyWidget();
}

class TestWidget extends StatefulWidget {
  const TestWidget({
    Key key,
    @required this.i,
    this.name,
  }) : super(key: key);

  final int i;
  final String name;

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TestWidget oldWidget) {
    print("widget rebuilt");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
}

extension on Widget {
  Widget asObservable() => Observer(builder: (context) {
        print(this);
        Element x = context as Element;
        x.markNeedsBuild();
        return this;
      });
}

// mixin Observ on StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print(this);
//     return Observer(builder: (_) => this);
//   }
// }

extension on List {
  Row asRow() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: this);
  Column asColumn() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: this);
}
