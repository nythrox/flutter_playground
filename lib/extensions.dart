extension Something<T> on T {
  T operator &(void doAdditionalStuff) {
    return this;
  }

  T operator |(void doAdditionalStuff) {
    return this;
  }

  T operator ^(void doAdditionalStuff) {
    return this;
  }

  T operator >>(T Function(T) fn) {
    return fn(this);
  }

  T operator >(T Function(T) fn) {
    return fn(this);
  }

  T operator <(T Function(T) fn) {
    return fn(this);
  }

  R pipe<R>(R Function(T) fn) {
    return fn(this);
  }

  T operator <<(void doAdditionalStuff) {
    return this;
  }

  @Deprecated('isNull is deprecated and cannot be used, use "==" operator')
  bool get isNull => this == null;

  bool get truthy {
    if (this == null) return false;
    if (this == false) return false;
    return true;
  }
}

class User {}

main() {
  final z = User() & print("hi") & print("owo");
  final hi = 0;
  final addOwo = (String str) => str + "owo";
  final hi2 = "hi" >> addOwo;
}
