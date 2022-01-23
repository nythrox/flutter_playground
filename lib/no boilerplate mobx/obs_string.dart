import 'package:mobx/mobx.dart';

class ObservableString implements Observable<String> {
  final Observable<String> obs;
  String get value => obs.value;
  ObservableString(String initialValue,
      {String name,
      ReactiveContext context,
      bool Function(String, String) equals})
      : obs = Observable(initialValue,
            name: name, context: context, equals: equals);
            

  @override
  String toString() => value.toString();

  /// The character (as a single-code-unit [String]) at the given [index].
  ///
  /// The returned string represents exactly one UTF-16 code unit, which may be
  /// half of a surrogate pair. A single member of a surrogate pair is an
  /// invalid UTF-16 string:
  /// ```dart
  /// var clef = '\u{1D11E}';
  /// // These represent invalid UTF-16 strings.
  /// clef[0].codeUnits;      // [0xD834]
  /// clef[1].codeUnits;      // [0xDD1E]
  /// ```
  /// This method is equivalent to
  /// `String.fromCharCode(this.codeUnitAt(index))`.
  String operator [](int index) => value[index];

  /// Returns the 16-bit UTF-16 code unit at the given [index].
  int codeUnitAt(int index) => value.codeUnitAt(index);

  /// The length of the string.
  ///
  /// Returns the number of UTF-16 code units in this string. The number
  /// of [runes] might be fewer, if the string contains characters outside
  /// the Basic Multilingual Plane (plane 0):
  /// ```dart
  /// 'Dart'.length;          // 4
  /// 'Dart'.runes.length;    // 4
  ///
  /// var clef = '\u{1D11E}';
  /// clef.length;            // 2
  /// clef.runes.length;      // 1
  /// ```
  int get length => value.length;

  /// A hash code derived from the code units of the string.
  ///
  /// This is compatible with [operator ==]. Strings with the same sequence
  /// of code units have the same hash code.
  int get hashCode => value.hashCode;

  /// Whether [other] is a `String` with the same sequence of code units.
  ///
  /// This method compares each individual code unit of the strings.
  /// It does not check for Unicode equivalence.
  /// For example, both the following strings represent the string 'Amélie',
  /// but due to their different encoding, are not equal:
  /// ```dart
  /// 'Am\xe9lie' == 'Ame\u{301}lie'; // false
  /// ```
  /// The first string encodes 'é' as a single unicode code unit (also
  /// a single rune), whereas the second string encodes it as 'e' with the
  /// combining accent character '◌́'.
  bool operator ==(Object other) => value == other;

  /// Compares this string to [other].
  ///
  /// Returns a negative value if `this` is ordered before `other`,
  /// a positive value if `this` is ordered after `other`,
  /// or zero if `this` and `other` are equivalent.
  ///
  /// The ordering is the same as the ordering of the code points at the first
  /// position where the two strings differ.
  /// If one string is a prefix of the other,
  /// then the shorter string is ordered before the longer string.
  /// If the strings have exactly the same content, they are equivalent with
  /// regard to the ordering.
  /// Ordering does not check for Unicode equivalence.
  /// The comparison is case sensitive.
  int compareTo(String other) => value.compareTo(other);

  /// Whether this string ends with [other].
  ///
  /// For example:
  /// ```dart
  /// 'Dart'.endsWith('t'); // true
  /// ```
  bool endsWith(String other) => value.endsWith(other);

  /// Whether this string starts with a match of [pattern].
  ///
  /// ```dart
  /// var string = 'Dart';
  /// string.startsWith('D');                       // true
  /// string.startsWith(RegExp(r'[A-Z][a-z]')); // true
  /// ```
  /// If [index] is provided, this method checks if the substring starting
  /// at that index starts with a match of [pattern]:
  /// ```dart
  /// string.startsWith('art', 1);                  // true
  /// string.startsWith(RegExp(r'\w{3}'));      // true
  /// ```
  /// [index] must not be negative or greater than [length].
  ///
  /// A [RegExp] containing '^' does not match if the [index] is greater than
  /// zero and the regexp is not multi-line.
  /// The pattern works on the string as a whole, and does not extract
  /// a substring starting at [index] first:
  /// ```dart
  /// string.startsWith(RegExp(r'^art'), 1);    // false
  /// string.startsWith(RegExp(r'art'), 1);     // true
  /// ```
  bool startsWith(Pattern pattern, [int index = 0]) =>
      value.startsWith(pattern, index);

  /// Returns the position of the first match of [pattern] in this string,
  /// starting at [start], inclusive:
  /// ```dart
  /// var string = 'Dartisans';
  /// string.indexOf('art');                     // 1
  /// string.indexOf(RegExp(r'[A-Z][a-z]')); // 0
  /// ```
  /// Returns -1 if no match is found:
  /// ```dart
  /// string.indexOf(RegExp(r'dart'));       // -1
  /// ```
  /// The [start] must be non-negative and not greater than [length].
  int indexOf(Pattern pattern, [int start = 0]) =>
      value.indexOf(pattern, start);

  /// The starting position of the last match [pattern] in this string.
  ///
  /// Finds a match of pattern by searching backward starting at [start]:
  /// ```dart
  /// var string = 'Dartisans';
  /// string.lastIndexOf('a');                    // 6
  /// string.lastIndexOf(RegExp(r'a(r|n)'));      // 6
  /// ```
  /// Returns -1 if [pattern] could not be found in this string.
  /// ```dart
  /// string.lastIndexOf(RegExp(r'DART'));        // -1
  /// ```
  /// If [start] is omitted, search starts from the end of the string.
  /// If supplied, [start] must be non-negative and not greater than [length].
  int lastIndexOf(Pattern pattern, [int start]) => lastIndexOf(pattern, start);

  /// Whether this string is empty.
  bool get isEmpty => value.isEmpty;

  /// Whether this string is not empty.
  bool get isNotEmpty => value.isNotEmpty;

  /// Creates a new string by concatenating this string with [other].
  ///
  /// Example:
  /// ```dart
  /// 'dart' + 'lang'; // 'dartlang'
  /// ```
  String operator +(String other) => value + other;

  /// The substring of this string from [start],inclusive, to [end], exclusive.
  ///
  /// Example:
  /// ```dart
  /// var string = 'dartlang';
  /// string.substring(1);    // 'artlang'
  /// string.substring(1, 4); // 'art'
  /// ```
  String substring(int start, [int end]) => value.substring(start, end);

  /// The string without any leading and trailing whitespace.
  ///
  /// If the string contains leading or trailing whitespace, a new string with no
  /// leading and no trailing whitespace is returned:
  /// ```dart
  /// '\tDart is fun\n'.trim(); // 'Dart is fun'
  /// ```
  /// Otherwise, the original string itself is returned:
  /// ```dart
  /// var str1 = 'Dart';
  /// var str2 = str1.trim();
  /// identical(str1, str2);    // true
  /// ```
  /// Whitespace is defined by the Unicode White_Space property (as defined in
  /// version 6.2 or later) and the BOM character, 0xFEFF.
  ///
  /// Here is the list of trimmed characters according to Unicode version 6.3:
  /// ```
  ///     0009..000D    ; White_Space # Cc   <control-0009>..<control-000D>
  ///     0020          ; White_Space # Zs   SPACE
  ///     0085          ; White_Space # Cc   <control-0085>
  ///     00A0          ; White_Space # Zs   NO-BREAK SPACE
  ///     1680          ; White_Space # Zs   OGHAM SPACE MARK
  ///     2000..200A    ; White_Space # Zs   EN QUAD..HAIR SPACE
  ///     2028          ; White_Space # Zl   LINE SEPARATOR
  ///     2029          ; White_Space # Zp   PARAGRAPH SEPARATOR
  ///     202F          ; White_Space # Zs   NARROW NO-BREAK SPACE
  ///     205F          ; White_Space # Zs   MEDIUM MATHEMATICAL SPACE
  ///     3000          ; White_Space # Zs   IDEOGRAPHIC SPACE
  ///
  ///     FEFF          ; BOM                ZERO WIDTH NO_BREAK SPACE
  /// ```
  /// Some later versions of Unicode do not include U+0085 as a whitespace
  /// character. Whether it is trimmed depends on the Unicode version
  /// used by the system.
  String trim() => value.trim();

  /// The string without any leading whitespace.
  ///
  /// As [trim], but only removes leading whitespace.
  String trimLeft() => value.trimLeft();

  /// The string without any trailing whitespace.
  ///
  /// As [trim], but only removes trailing whitespace.
  String trimRight() => value.trimRight();

  /// Creates a new string by concatenating this string with itself a number
  /// of times.
  ///
  /// The result of `str * n` is equivalent to
  /// `str + str + ...`(n times)`... + str`.
  ///
  /// Returns an empty string if [times] is zero or negative.
  String operator *(int times) => value * times;

  /// Pads this string on the left if it is shorter than [width].
  ///
  /// Returns a new string that prepends [padding] onto this string
  /// one time for each position the length is less than [width].
  ///
  /// If [width] is already smaller than or equal to `this.length`,
  /// no padding is added. A negative `width` is treated as zero.
  ///
  /// If [padding] has length different from 1, the result will not
  /// have length `width`. This may be useful for cases where the
  /// padding is a longer string representing a single character, like
  /// `"&nbsp;"` or `"\u{10002}`".
  /// In that case, the user should make sure that `this.length` is
  /// the correct measure of the strings length.
  String padLeft(int width, [String padding = ' ']) =>
      value.padLeft(width, padding);

  /// Pads this string on the right if it is shorter than [width].
  ///
  /// Returns a new string that appends [padding] after this string
  /// one time for each position the length is less than [width].
  ///
  /// If [width] is already smaller than or equal to `this.length`,
  /// no padding is added. A negative `width` is treated as zero.
  ///
  /// If [padding] has length different from 1, the result will not
  /// have length `width`. This may be useful for cases where the
  /// padding is a longer string representing a single character, like
  /// `"&nbsp;"` or `"\u{10002}`".
  /// In that case, the user should make sure that `this.length` is
  /// the correct measure of the strings length.
  String padRight(int width, [String padding = ' ']) =>
      value.padRight(width, padding);

  /// Whether this string contains a match of [other].
  ///
  /// Example:
  /// ```dart
  /// var string = 'Dart strings';
  /// string.contains('D');                     // true
  /// string.contains(RegExp(r'[A-Z]'));    // true
  /// ```
  /// If [startIndex] is provided, this method matches only at or after that
  /// index:
  /// ```dart
  /// string.contains('D', 1);                  // false
  /// string.contains(RegExp(r'[A-Z]'), 1); // false
  /// ```
  /// The [startIndex] must not be negative or greater than [length].
  bool contains(Pattern other, [int startIndex = 0]) =>
      value.contains(other, startIndex);

  /// Creates a new string with the first occurrence of [from] replaced by [to].
  ///
  /// Finds the first match of [from] in this string, starting from [startIndex],
  /// and creates a new string where that match is replaced with the [to] string.
  ///
  /// Example:
  /// ```dart
  /// '0.0001'.replaceFirst(RegExp(r'0'), ''); // '.0001'
  /// '0.0001'.replaceFirst(RegExp(r'0'), '7', 1); // '0.7001'
  /// ```
  String replaceFirst(Pattern from, String to, [int startIndex = 0]) =>
      value.replaceFirst(from, to, startIndex);

  /// Replace the first occurrence of [from] in this string.
  ///
  /// Returns a new string, which is this string
  /// except that the first match of [from], starting from [startIndex],
  /// is replaced by the result of calling [replace] with the match object.
  ///
  /// The [startIndex] must be non-negative and no greater than [length].
  String replaceFirstMapped(Pattern from, String replace(Match match),
          [int startIndex = 0]) =>
      value.replaceFirstMapped(from, replace, startIndex);

  /// Replaces all substrings that match [from] with [replace].
  ///
  /// Creates a new string in which the non-overlapping substrings matching
  /// [from] (the ones iterated by `from.allMatches(thisString)`) are replaced
  /// by the literal string [replace].
  /// ```dart
  /// 'resume'.replaceAll(RegExp(r'e'), 'é'); // 'résumé'
  /// ```
  /// Notice that the [replace] string is not interpreted. If the replacement
  /// depends on the match (for example on a [RegExp]'s capture groups), use
  /// the [replaceAllMapped] method instead.
  String replaceAll(Pattern from, String replace) => replaceAll(from, replace);

  /// Replace all substrings that match [from] by a computed string.
  ///
  /// Creates a new string in which the non-overlapping substrings that match
  /// [from] (the ones iterated by `from.allMatches(thisString)`) are replaced
  /// by the result of calling [replace] on the corresponding [Match] object.
  ///
  /// This can be used to replace matches with new content that depends on the
  /// match, unlike [replaceAll] where the replacement string is always the same.
  ///
  /// The [replace] function is called with the [Match] generated
  /// by the pattern, and its result is used as replacement.
  ///
  /// The function defined below converts each word in a string to simplified
  /// 'pig latin' using [replaceAllMapped]:
  /// ```dart
  /// pigLatin(String words) => words.replaceAllMapped(
  ///     RegExp(r'\b(\w*?)([aeiou]\w*)', caseSensitive: false),
  ///     (Match m) => "${m[2]}${m[1]}${m[1]!.isEmpty ? 'way' : 'ay'}");
  ///
  ///     pigLatin('I have a secret now!'); // 'Iway avehay away ecretsay ownay!'
  /// ```
  String replaceAllMapped(Pattern from, String Function(Match match) replace) =>
      value.replaceAllMapped(from, replace);

  /// Replaces the substring from [start] to [end] with [replacement].
  ///
  /// Creates a new string equivalent to:
  /// ```dart
  /// this.substring(0, start) + replacement + this.substring(end)
  /// ```
  /// The [start] and [end] indices must specify a valid range of this string.
  /// That is `0 <= start <= end <= this.length`.
  /// If [end] is `null`, it defaults to [length].
  String replaceRange(int start, int end, String replacement) =>
      value.replaceRange(start, end, replacement);

  /// Splits the string at matches of [pattern] and returns a list of substrings.
  ///
  /// Finds all the matches of `pattern` in this string,
  /// and returns the list of the substrings between the matches.
  /// ```dart
  /// var string = "Hello world!";
  /// string.split(" ");                      // ['Hello', 'world!'];
  /// ```
  /// Empty matches at the beginning and end of the strings are ignored,
  /// and so are empty matches right after another match.
  /// ```dart
  /// var string = "abba";
  /// // Matches:   ^^ ^^
  /// string.split(RegExp(r"b*"));        // ['a', 'a']
  ///                                         // not ['', 'a', 'a', '']
  ///                                         // not ['a', '', 'a']
  /// ```
  /// If this string is empty, the result is an empty list if `pattern` matches
  /// the empty string, and it is `[""]` if the pattern doesn't match.
  /// ```dart
  /// var string = '';
  /// string.split('');                       // []
  /// string.split("a");                      // ['']
  /// ```
  /// Splitting with an empty pattern splits the string into single-code unit
  /// strings.
  /// ```dart
  /// var string = 'Pub';
  /// string.split('');                       // ['P', 'u', 'b']
  ///
  /// string.codeUnits.map((unit) {
  ///   return String.fromCharCode(unit);
  /// }).toList();                            // ['P', 'u', 'b']
  /// ```
  /// Splitting happens at UTF-16 code unit boundaries,
  /// and not at rune boundaries:
  /// ```dart
  /// // String made up of two code units, but one rune.
  /// string = '\u{1D11E}';
  /// string.split('').length;                 // 2 surrogate values
  /// ```
  /// To get a list of strings containing the individual runes of a string,
  /// you should not use split. You can instead map each rune to a string
  /// as follows:
  /// ```dart
  /// string.runes.map((rune) => String.fromCharCode(rune)).toList();
  /// ```
  List<String> split(Pattern pattern) => value.split(pattern);

  /// Splits the string, converts its parts, and combines them into a new
  /// string.
  ///
  /// The [pattern] is used to split the string
  /// into parts and separating matches.
  ///
  /// Each match is converted to a string by calling [onMatch]. If [onMatch]
  /// is omitted, the matched substring is used.
  ///
  /// Each non-matched part is converted by a call to [onNonMatch]. If
  /// [onNonMatch] is omitted, the non-matching substring is used.
  ///
  /// Then all the converted parts are combined into the resulting string.
  /// ```dart
  /// 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
  ///     onMatch:    (m) => '${m[0]!}',  // or no onMatch at all
  ///     onNonMatch: (n) => '*'); // *shoots*
  /// ```
  String splitMapJoin(Pattern pattern,
          {String Function(Match) onMatch,
          String Function(String) onNonMatch}) =>
      value.splitMapJoin(pattern, onMatch: onMatch, onNonMatch: onNonMatch);

  /// An unmodifiable list of the UTF-16 code units of this string.
  List<int> get codeUnits => value.codeUnits;

  /// An [Iterable] of Unicode code-points of this string.
  ///
  /// If the string contains surrogate pairs, they are combined and returned
  /// as one integer by this iterator. Unmatched surrogate halves are treated
  /// like valid 16-bit code-units.
  Runes get runes => value.runes;

  /// Converts all characters in this string to lower case.
  ///
  /// If the string is already in all lower case, this method returns `this`.
  /// ```dart
  /// 'ALPHABET'.toLowerCase(); // 'alphabet'
  /// 'abc'.toLowerCase();      // 'abc'
  /// ```
  /// This function uses the language independent Unicode mapping and thus only
  /// works in some languages.
  // TODO(floitsch): document better. (See EcmaScript for description).
  String toLowerCase() => value.toLowerCase();

  /// Converts all characters in this string to upper case.
  ///
  /// If the string is already in all upper case, this method returns `this`.
  /// ```dart
  /// 'alphabet'.toUpperCase(); // 'ALPHABET'
  /// 'ABC'.toUpperCase();      // 'ABC'
  /// ```
  /// This function uses the language independent Unicode mapping and thus only
  /// works in some languages.
  // TODO(floitsch): document better. (See EcmaScript for description).
  String toUpperCase() => value.toUpperCase();

  @override
  ReactiveContext get context => obs.context;

  @override
  get equals => obs.equals;

  @override
  bool get hasObservers => obs.hasObservers;

  @override
  intercept(interceptor) => obs.intercept(interceptor);

  @override
  String get name => obs.name;

  @override
  observe(listener, {bool fireImmediately}) =>
      obs.observe(listener, fireImmediately: fireImmediately);

  @override
  void Function() onBecomeObserved(Function fn) => obs.onBecomeObserved(fn);

  @override
  void Function() onBecomeUnobserved(Function fn) => obs.onBecomeUnobserved(fn);

  @override
  void reportChanged() => obs.reportChanged();

  @override
  void reportObserved() => obs.reportObserved();

  @override
  set value(String value) => obs.value = value;
}
