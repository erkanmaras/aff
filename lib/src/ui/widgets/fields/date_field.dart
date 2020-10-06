import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:provider/provider.dart';

class DateField extends StatefulWidget {
  DateField({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.datePickerMode = DatePickerMode.day,
    this.hintText,
    this.errorText,
    this.enable = true,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.onClear,
  }) : super(key: key);

  /// Callback when datetime selected [DateTime]
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onClear;

  /// Selected date;
  final DateTime value;

  /// Default is 1900.
  final DateTime firstDate;

  /// Default is 2100.
  final DateTime lastDate;

  final String hintText;
  final String errorText;
  final DateFormat dateFormat;
  final bool enable;

  /// If DateTimeFieldMode is date , you can choose the [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode datePickerMode;

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  Future<void> _showPicker(BuildContext context) async {
    final DateTime firstDate = widget.firstDate ?? DateTime(1900);
    final DateTime lastDate = widget.lastDate ?? DateTime(2100);
    DateTime _selectedDateTime;

    final DateTime _selectedDate = await showDatePicker(
        context: context,
        initialDatePickerMode: widget.datePickerMode,
        initialDate: widget.value ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);

    if (_selectedDate != null) {
      _selectedDateTime = _selectedDate;
    }

    if (_selectedDateTime != null) {
      widget.onChanged(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Provider.of<AppTheme>(context, listen: false);
    String text;

    if (widget.value != null) {
      text = (widget.dateFormat ?? ValueFormat.dateFormat()).format(widget.value);
    }

    FieldButton suffixButton;
    if (widget.onClear != null && !text.isNullOrWhiteSpace()) {
      suffixButton =
          FieldButton.clear(onTab: widget.onClear, enable: widget.enable);
    } else {
      suffixButton = FieldButton.calender(enable: widget.enable);
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

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key key,
    @required DateTime value,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    AutovalidateMode autovalidateMode,
    bool enabled = true,
    String hintText,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.datePickerMode = DatePickerMode.day,
  }) : super(
          key: key,
          initialValue: value,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (FormFieldState<DateTime> field) {
            final _DateTimeFormFieldState state =
                field as _DateTimeFormFieldState;

            void onChangedHandler(DateTime value) {
              if (onDateSelected != null) {
                onDateSelected(value);
              }
              field.didChange(value);
            }

            return DateField(
                firstDate: firstDate,
                lastDate: lastDate,
                datePickerMode: datePickerMode,
                dateFormat: dateFormat,
                hintText: hintText,
                errorText: state.errorText,
                onChanged: onChangedHandler,
                value: value,
                enable: enabled);
          },
        );

  /// DateTime is selected  callback
  final ValueChanged<DateTime> onDateSelected;

  /// The first date that the user can select (default is 1900)
  final DateTime firstDate;

  /// The last date that the user can select (default is 2100)
  final DateTime lastDate;

  /// How to display the [DateTime] for the user (default is [DateFormat.yMMMD])
  final DateFormat dateFormat;

  /// [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode datePickerMode;

  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  @override
  void didUpdateWidget(FormField<DateTime> oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
