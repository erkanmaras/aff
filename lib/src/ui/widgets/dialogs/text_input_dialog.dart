import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';

class TextInputDialog extends StatefulWidget {
  TextInputDialog(
      {@required this.title,
      this.titlePadding,
      this.titleTextStyle,
      this.backgroundColor,
      this.elevation,
      this.semanticLabel,
      this.shape,
      this.value,
      this.textInputDecoration,
      this.onValidation,
      this.additionalActions,
      Key key})
      : super(key: key);

  final Widget title;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle titleTextStyle;

  final Color backgroundColor;

  final double elevation;

  final String semanticLabel;

  final ShapeBorder shape;

  final String value;

  final InputDecoration textInputDecoration;

  final String Function(String value) onValidation;

  final List<Widget> additionalActions;

  @override
  State<StatefulWidget> createState() => _TextInputDialogState();

  static Future<ValueDialogResult<String>> show(
      BuildContext context, String titleText) async {
    return showDialog<ValueDialogResult<String>>(
      context: context,
      builder: (context) {
        return TextInputDialog(
          title: Text(titleText),
        );
      },
    );
  }
}

class _TextInputDialogState extends State<TextInputDialog> {
  final TextEditingController controller = TextEditingController();
  String errorText;

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    var content = TextField(
        controller: controller,
        decoration: (widget.textInputDecoration ?? InputDecoration())
            .copyWith(errorText: errorText),
        autofocus: true);
    return InputDialog(
        title: widget.title,
        content: content,
        onOkPressed: () {
          if (widget.onValidation != null) {
            var error = widget.onValidation(controller.text);
            if (!error.isNullOrEmpty()) {
              setState(() {
                errorText = error;
              });
              return;
            }
          }
          Navigator.pop(context,
              ValueDialogResult(DialogResult.ok, value: controller.text));
        },
        onCancelPressed: () {
          Navigator.pop(
              context, ValueDialogResult<String>(DialogResult.cancel));
        },
        titleTextStyle: widget.titleTextStyle,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        semanticLabel: widget.semanticLabel,
        shape: widget.shape,
        titlePadding: widget.titlePadding,
        additionalActions: widget.additionalActions);
  }
}
