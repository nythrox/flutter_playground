import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

extension on Future {
  ObservableFuture toObservable<T>() => ObservableFuture<T>(this);
  ObservableFuture asObservable<T>() => ObservableFuture<T>(this);
}

extension on State {
  ObservableFuture<T> doAsyncOperation<T>(Future<T> future) {
    final of = ObservableFuture<T>(future);
    of.then((value) => setState(() {}));
    return of;
  }
}

extension on ObservableFuture {
  get isPending => this.status == FutureStatus.pending;
  get isFulfilled => this.status == FutureStatus.fulfilled;
  get isRejected => this.status == FutureStatus.rejected;
}

extension on FutureStatus {
  get isPending => this == FutureStatus.pending;
  get isFulfilled => this == FutureStatus.fulfilled;
  get isRejected => this == FutureStatus.rejected;
}

class ApiRepository {
  Future<int> getNumber() {
    return Future.delayed(Duration(seconds: 1)).then((value) => 2);
  }
}

class ApiCall extends StatefulWidget {
  @override
  _ApiCallState createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {
  ObservableFuture<int> number;
  final apiRepository = ApiRepository();

  @override
  void initState() {
    super.initState();
    // number = doAsyncOperation(apiRepository.getNumber());
    number = apiRepository.getNumber().asObservable<int>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (c) {
      if (number.isPending) {
        return CircularProgressIndicator();
      }
      return Text(number.value.toString());
    });
  }
}
