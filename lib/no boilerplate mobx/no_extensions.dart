import 'package:mobx/mobx.dart';

class HI {
  final count = Observable(0);

  late final doubledCount = Computed(() => 2 * count.value);

  void increment2() => runInAction(() {
    count.value++;
    count.value++;
  });
  
  late final increment = Action(() {
    count.value++;
  });

}
