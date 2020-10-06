import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:provider/provider.dart';

class TimeField extends StatefulWidget {
  TimeField({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.hintText,
    this.errorText,
    this.enable = true,
    this.onClear,
  }) : super(key: key);

  /// Callback when TimeOfDay selected
  final ValueChanged<TimeOfDay> onChanged;
  final VoidCallback onClear;

  /// Selected TimeOfDay;
  final TimeOfDay value;

  final String hintText;
  final String errorText;
  final bool enable;

  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  Future<void> _showPicker(BuildContext context) async {
    final TimeOfDay _selectedTime = await showTimePicker(
      initialTime: widget.value ?? TimeOfDay.fromDateTime(DateTime.now()),
      context: context,
    );

    if (_selectedTime != null) {
      widget.onChanged(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Provider.of<AppTheme>(context, listen: false);
    String text;

    if (widget.value != null) {
      text = widget.value.format(context);
    }

    FieldButton suffixButton;
    if (widget.onClear != null && !text.isNullOrWhiteSpace()) {
      suffixButton =
          FieldButton.clear(onTab: widget.onClear, enable: widget.enable);
    } else {
      suffixButton = FieldButton.clock(enable: widget.enable);
    }

    return GestureDetector(
      onTap: widget.enable ? () async => _showPicker(context) : null,
      child: InputDecorator(
        decoration: DenseInputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          suffixIcon: suffixButton,
          errorText: widget.errorText,
          hintText: widget.hintText,
          border: widget.enable
              ? appTheme.data.inputDecorationTheme.enabledBorder
              : appTheme.data.inputDecorationTheme.disabledBorder,
        ),
        child: Text(
          text.isNullOrWhiteSpace() ? widget.hintText ?? '' : text,
          style: appTheme.textStyles.subtitle.copyWith(
              color: text.isNullOrWhiteSpace()
                  ? appTheme.data.inputDecorationTheme.hintStyle.color
                  : appTheme.colors.font),
        ),
      ),
    );
  }
}

class TimeFormField extends FormField<TimeOfDay> {
  TimeFormField(
      {Key key,
      @required TimeOfDay value,
      FormFieldSetter<TimeOfDay> onSaved,
      FormFieldValidator<TimeOfDay> validator,
      AutovalidateMode autovalidateMode,
      bool enabled = true,
      String hintText,
      this.onDateSelected})
      : super(
          key: key,
          initialValue: value,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (FormFieldState<TimeOfDay> field) {
            final _TimeFormFieldState state = field as _TimeFormFieldState;

            void onChangedHandler(TimeOfDay value) {
              if (onDateSelected != null) {
                onDateSelected(value);
              }
              field.didChange(value);
            }

            return TimeField(
                hintText: hintText,
                errorText: state.errorText,
                onChanged: onChangedHandler,
                value: value,
                enable: enabled);
          },
        );

  /// TimeOfDay is selected  callback
  final ValueChanged<TimeOfDay> onDateSelected;

  @override
  _TimeFormFieldState createState() => _TimeFormFieldState();
}

class _TimeFormFieldState extends FormFieldState<TimeOfDay> {
  @override
  void didUpdateWidget(FormField<TimeOfDay> oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
