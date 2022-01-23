
import 'package:flutter/material.dart';
import 'package:flutter_tests_projects/functional+hooks/functionalWidgetStuff.dart';

/// Creates and dispose of a [FocusNode].
///
/// See also:
/// - [FocusNode]
FocusNode useFocusNode() => Hook.use(const _FocusNodeHook());

class _FocusNodeHook extends Hook<FocusNode> {
  const _FocusNodeHook();

  @override
  _FocusNodeHookState createState() {
    return _FocusNodeHookState();
  }
}

class _FocusNodeHookState extends HookState<FocusNode, _FocusNodeHook> {
  final _focusNode = FocusNode();

  @override
  FocusNode build(BuildContext context) => _focusNode;

  @override
  void dispose() => _focusNode?.dispose();
}