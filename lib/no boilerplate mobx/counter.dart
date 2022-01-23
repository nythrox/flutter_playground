import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'obs_double.dart';
import 'obs_int.dart';
import 'obs_string.dart';

extension ObsString on String {
  ObservableString get obs => ObservableString(this);
}
extension ObsInt on int {
  ObservableInt get obs => ObservableInt(this);
}
extension ObsDouble on double {
  ObservableDouble get obs => ObservableDouble(this);
}

extension Obs<T> on T {
  Observable<T> get obs => Observable(this);
}

class Hi {
  final jason = null.obs<String?>();
}

extension Call on Observable<Null> {
  Observable<U> call<U>() {
    return this as Observable<U>;
  }
}

extension ObsFtr<T> on Future<T> {
  ObservableFuture<T> get obs => ObservableFuture(this); 
}

extension ComputedObs<T> on T Function() {
  Computed<T> get obs => Computed(this);
}

final comp = <T>(T Function() computed) => Computed(() => computed()).value;
final obs =
    (Widget Function() builder) => Observer(builder: (context) => builder());
