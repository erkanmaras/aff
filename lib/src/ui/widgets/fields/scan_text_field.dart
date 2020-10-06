import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';

class ScanTextField extends StatefulWidget {
  const ScanTextField(
      {Key key,
      this.controller,
      this.focusNode,
      this.decoration = const DenseInputDecoration(),
      this.cursorColor,
      this.textInputAction,
      this.splashColor,
      this.onSubmitted,
      this.onScaned,
      this.onClear,
      this.autofocus = false})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final Color cursorColor;
  final Color splashColor;
  final TextInputAction textInputAction;
  final bool autofocus;
  final Function(String) onSubmitted;
  final Function(String) onScaned;
  final VoidCallback onClear;
  @override
  _ScanTextFieldState createState() => _ScanTextFieldState();
}

class _ScanTextFieldState extends State<ScanTextField> {
  TextEditingController _controller;

  bool _showClearButton;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  bool get _hasText => !_effectiveController.text.isNullOrEmpty();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController.addListener(_onTextChanged);
    _showClearButton = _hasText;
  }

  @override
  void didUpdateWidget(ScanTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
        _controller.addListener(_onTextChanged);
      } else {
        _showClearButton = !widget.controller.text.isNullOrEmpty();
        if (oldWidget.controller == null) {
          _controller.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _handleKey,
        child: TextField(
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            controller: _effectiveController,
            cursorColor: widget.cursorColor,
            decoration: widget.decoration
                .copyWith(suffixIcon: _buildInputSuffixButton()),
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus));
  }

  void _handleKey(RawKeyEvent event) {
    if ((event.runtimeType == RawKeyDownEvent) &&
        (event.logicalKey == LogicalKeyboardKey.enter)) {
      widget.onScaned(_effectiveController.text);
    }
  }

  Widget _buildInputSuffixButton() {
    return _showClearButton
        ? FieldButton(
            iconData: AppIcons.close,
            onTab: () {
              _effectiveController.clear();
              if (widget.onClear != null) {
                widget.onClear();
              }
            },
          )
        : null;
  }

  void _onTextChanged() {
    if (_showClearButton != _hasText) {
      setState(() {
        _showClearButton = _hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }
}
