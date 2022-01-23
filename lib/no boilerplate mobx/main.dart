import 'package:flutter/material.dart' hide Action;
import 'package:mobx/mobx.dart';
import 'counter.dart';

void main() {
  mainContext.config =
      mainContext.config.clone(writePolicy: ReactiveWritePolicy.never);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TestCounterStore {
  final count = 0.obs;
  final name = "jason".obs;

  int get doubleValue => count.value * 2;

  void increment() {
    count.value++;
    name.value = "jason " * count.value;
  }
}

final action = runInAction;



final store = TestCounterStore();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            obs(() => Text(
                  'Hi ${store.name}, You have pushed the button this many times:',
                )),
            obs(() => Text(
                  '${store.count.value}',
                  style: Theme.of(context).textTheme.headline4,
                )),
            obs(() => Text(
                  '${store.doubleValue}',
                  style: Theme.of(context).textTheme.headline4,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: store.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  
}
