import 'package:flutter/widgets.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
class KeyboardStateBuilder extends StatefulWidget {
  KeyboardStateBuilder({@required this.child});

  final Widget child;
  @override
  _KeyboardStateBuilderState createState() => _KeyboardStateBuilderState();
}

class _KeyboardStateBuilderState extends State<KeyboardStateBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  bool _keyboardVisible = false;
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    var keyboardVisible = context.getMediaQuery().keyboardVisible();
    if (_keyboardVisible != keyboardVisible && mounted) {
      setState(() {
        _keyboardVisible = keyboardVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
