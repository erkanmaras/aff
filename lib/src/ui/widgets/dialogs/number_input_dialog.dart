import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
 
class NumberInputDialog extends StatefulWidget {
  NumberInputDialog(
      {@required this.title,
      this.titlePadding,
      this.titleTextStyle,
      this.backgroundColor,
      this.elevation,
      this.semanticLabel,
      this.shape,
      this.value = 0,
      this.minValue,
      this.maxValue,
      this.textInputDecoration,
      this.onValidation,
      this.additionalActions,
      Key key})
      : assert(value != null),
        assert(minValue == null || minValue <= value,
            'value must be equal or greater than minValue'),
        assert(maxValue == null || maxValue >= value,
            'value must be equal or lower than maxValue'),
        assert(minValue == null || maxValue == null || maxValue > minValue,
            'maxValue must be greater than minValue'),
        super(key: key);

  final Widget title;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle titleTextStyle;

  final Color backgroundColor;

  final double elevation;

  final String semanticLabel;

  final ShapeBorder shape;

  final num value;

  final num minValue;

  final num maxValue;

  final InputDecoration textInputDecoration;

  final String Function(num value) onValidation;

  final List<Widget> additionalActions;

  @override
  State<StatefulWidget> createState() => _NumberInputDialogState();

  static Future<ValueDialogResult<num>> show(
      BuildContext context, String titleText,
      {num value, num minValue}) async {
    return showDialog<ValueDialogResult<num>>(
      context: context,
      builder: (context) {
        return NumberInputDialog(
          title: Text(titleText),
          value: value ?? 0,
          minValue: minValue ?? 0,
        );
      },
    );
  }
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  final TextEditingController tec = TextEditingController();
  final FocusNode fn = FocusNode();
  String errorText;
  num get value => num.parse(tec.text);

  @override
  void initState() {
    super.initState();
    _assignValueToController(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    var contentBody = <Widget>[];
    contentBody.add(TextButton(
        onPressed: () {
          _assignValueToController(value - 1);
          fn.unfocus();
        },
        child: Icon(AppIcons.minus)));
    contentBody.add(TextField(
      controller: tec,
      onSubmitted: (val) {
        popWithValidate();
      },
      decoration: (widget.textInputDecoration ?? InputDecoration())
          .copyWith(errorText: errorText),
      keyboardType: TextInputType.number,
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isNullOrEmpty()) {
            return oldValue.copyWith(
                selection: TextSelection(
                    baseOffset: 0, extentOffset: oldValue.text.length));
          }
          final newNumValue = num.tryParse(newValue.text);
          if (newNumValue != null) {
            return newValue.copyWith(
                text: _getBoundedValue(newNumValue).toString());
          }
          return oldValue;
        })
      ],
      textAlign: TextAlign.center,
      focusNode: fn,
    ));
    contentBody.add(TextButton(
        onPressed: () {
          _assignValueToController(value + 1);
          fn.unfocus();
        },
        child: Icon(AppIcons.plus)));
    return InputDialog(
        title: widget.title,
        content: ExpandedRow(
          children: contentBody,
        ),
        onOkPressed: popWithValidate,
        onCancelPressed: () {
          Navigator.pop(context, ValueDialogResult<num>(DialogResult.cancel));
        },
        titleTextStyle: widget.titleTextStyle,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        semanticLabel: widget.semanticLabel,
        shape: widget.shape,
        titlePadding: widget.titlePadding,
        additionalActions: widget.additionalActions);
  }

  @override
  void didUpdateWidget(NumberInputDialog oldWidget) {
    if (oldWidget.value != widget.value) {
      _assignValueToController(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tec.dispose();
    fn.dispose();
    super.dispose();
  }

  void _assignValueToController(num value) {
    tec.text = _getBoundedValue(value).toString();
  }

  num _getBoundedValue(num value) {
    if (widget.minValue != null && widget.minValue > value) {
      value = widget.minValue;
    } else if (widget.maxValue != null && widget.maxValue < value) {
      value = widget.maxValue;
    }
    return value;
  }

  void popWithValidate() {
    if (widget.onValidation != null) {
      var error = widget.onValidation(value);
      if (!error.isNullOrEmpty()) {
        setState(() {
          errorText = error;
        });
        return;
      }
    }
    Navigator.pop(context, ValueDialogResult(DialogResult.ok, value: value));
  }
}
