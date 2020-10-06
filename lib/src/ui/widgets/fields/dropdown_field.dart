import 'package:flutter/material.dart';
import 'package:aff/ui.dart';

class DropdownField<T> extends StatelessWidget {
  DropdownField(
      {@required this.items,
      this.selectedItemBuilder,
      this.value,
      @required this.onChanged,
      this.style,
      this.hintText,
      this.hintStyle,
      this.disabledHintText,
      this.disabledHintStyle,
      this.autofocus = false,
      this.isExpanded = true,
      this.errorText});

  final List<DropdownMenuItem<T>> items;
  final DropdownButtonBuilder selectedItemBuilder;
  final T value;
  final ValueChanged<T> onChanged;
  final TextStyle style;
  final bool autofocus;
  final String hintText;
  final String disabledHintText;
  final TextStyle hintStyle;
  final TextStyle disabledHintStyle;
  final bool isExpanded;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return InputDecorator(
      decoration: DenseInputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 8, 15, 8),
          border: appTheme.data.inputDecorationTheme.enabledBorder,
          errorText: errorText),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
            style: style,
            autofocus: autofocus,
            iconEnabledColor: appTheme.colors.font,
            iconDisabledColor: appTheme.colors.fontPale,
            value: value,
            isDense: true,
            isExpanded: isExpanded,
            onChanged: onChanged,
            items: items,
            hint: Text(hintText ?? '',
                style:
                    hintStyle ?? appTheme.data.inputDecorationTheme.hintStyle),
            disabledHint: Text(disabledHintText ?? '',
                style: disabledHintStyle ??
                    appTheme.data.inputDecorationTheme.hintStyle)),
      ),
    );
  }
}

class DropdownFormField<T> extends FormField<T> {
  DropdownFormField({
    @required this.items,
    this.selectedItemBuilder,
    this.value,
    @required this.onChanged,
    this.style,
    this.hintText,
    this.hintStyle,
    this.disabledHintText,
    this.disabledHintStyle,
    this.autofocus = false,
    this.isExpanded = true,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    AutovalidateMode autovalidateMode,
    bool enabled = true,
  }) : super(
            initialValue: value,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<T> field) {
              void onChangedHandler(T value) {
                if (onChanged != null) {
                  onChanged(value);
                }
                field.didChange(value);
              }

              return DropdownField<T>(
                  items: items,
                  selectedItemBuilder: selectedItemBuilder,
                  value: field.value,
                  onChanged: onChangedHandler,
                  style: style,
                  hintText: hintText,
                  hintStyle: hintStyle,
                  disabledHintText: disabledHintText,
                  disabledHintStyle: disabledHintStyle,
                  autofocus: autofocus,
                  isExpanded: isExpanded,
                  errorText: field.errorText);
            });

  final List<DropdownMenuItem<T>> items;
  final DropdownButtonBuilder selectedItemBuilder;
  final T value;
  final ValueChanged<T> onChanged;
  final TextStyle style;
  final bool autofocus;
  final String hintText;
  final String disabledHintText;
  final TextStyle hintStyle;
  final TextStyle disabledHintStyle;
  final bool isExpanded;

  @override
  FormFieldState<T> createState() => _DropDownFormFieldState<T>();
}

class _DropDownFormFieldState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
