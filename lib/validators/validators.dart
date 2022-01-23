// class Password {
//   final String value;
//   Password(this.value) {
//     validate(value, [NotBlankString(), Length(min: 6, max: 8)]);
//   }
// }

// class Email {
//   final String value;
//   Email(this.value) {
//     validate(value, [IsEmail()]);
//   }
// }

// abstract class Validator<T, R> {
//   R validate(T value);
// }

// validate<T, R>(T value, List<Validator<T, R>> validators) {}

// class NotBlankString implements Validator<String, void> {
//   @override
//   void validate(String value) {}
// }

// class Length implements Validator<String, void> {
//   final int min;
//   final int max;

//   Length({required this.min = 0, required this.max = double.infinity});

//   void validate(String value);
// }
