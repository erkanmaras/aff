import 'package:aff/ui.dart';

class ValueDialogResult<T> {
  ValueDialogResult(this.dialogResult, {this.value});

  final DialogResult dialogResult;

  final T value;
}
