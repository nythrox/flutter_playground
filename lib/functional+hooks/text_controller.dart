
import 'package:flutter/material.dart';
import 'package:flutter_tests_projects/functional+hooks/functionalWidgetStuff.dart';

class _TextEditingControllerHookCreator {
  const _TextEditingControllerHookCreator();

  /// Creates a [TextEditingController] that will be disposed automatically.
  ///
  /// The [text] parameter can be used to set the initial value of the
  /// controller.
  TextEditingController call({String text, List<Object> keys}) {
    return Hook.use(_TextEditingControllerHook(text, null, keys));
  }

  /// Creates a [TextEditingController] from the initial [value] that will
  /// be disposed automatically.
  TextEditingController fromValue(TextEditingValue value, [List<Object> keys]) {
    return Hook.use(_TextEditingControllerHook(null, value, keys));
  }
}

/// Creates a [TextEditingController], either via an initial text or an initial
/// [TextEditingValue].
///
/// To use a [TextEditingController] with an optional initial text, use
/// ```dart
/// final controller = useTextEditingController(text: 'initial text');
/// ```
///
/// To use a [TextEditingController] with an optional inital value, use
/// ```dart
/// final controller = useTextEditingController
///   .fromValue(TextEditingValue.empty);
/// ```
///
/// Changing the text or initial value after the widget has been built has no
/// effect whatsoever. To update the value in a callback, for instance after a
/// button was pressed, use the [TextEditingController.text] or
/// [TextEditingController.text] setters. To have the [TextEditingController]
/// reflect changing values, you can use [useEffect]. This example will update
/// the [TextEditingController.text] whenever a provided [ValueListenable]
/// changes:
/// ```dart
/// final controller = useTextEditingController();
/// final update = useValueListenable(myTextControllerUpdates);
///
/// useEffect(() {
///   controller.text = update;
///   return null; // we don't need to have a special dispose logic
/// }, [update]);
/// ```
///
/// See also:
/// - [TextEditingController], which this hook creates.
const useTextEditingController = _TextEditingControllerHookCreator();

class _TextEditingControllerHook extends Hook<TextEditingController> {
  final String initialText;
  final TextEditingValue initialValue;

  _TextEditingControllerHook(this.initialText, this.initialValue,
      [List<Object> keys])
      : assert(
          initialText == null || initialValue == null,
          "initialText and intialValue can't both be set on a call to "
          'useTextEditingController!',
        ),
        super(keys: keys);

  @override
  _TextEditingControllerHookState createState() {
    return _TextEditingControllerHookState();
  }
}

class _TextEditingControllerHookState
    extends HookState<TextEditingController, _TextEditingControllerHook> {
  TextEditingController _controller;

  @override
  void initHook() {
    if (hook.initialValue != null) {
      _controller = TextEditingController.fromValue(hook.initialValue);
    } else {
      _controller = TextEditingController(text: hook.initialText);
    }
  }

  @override
  TextEditingController build(BuildContext context) => _controller;

  @override
  void dispose() => _controller?.dispose();
}