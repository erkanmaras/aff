import 'package:aff/infrastructure.dart';
import 'package:aff/src/ui/theme/theme.dart';
import 'package:aff/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common/test_app.dart';

void main() {
  testWidgets('Can have an Initial Value', (tester) async {
    await tester.pumpWidget(NumberInputDialogWrapper(value: 5));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);
  });
  testWidgets('Increment button increments TextValue by one', (tester) async {
    await tester.pumpWidget(NumberInputDialogWrapper());
    await tester.pumpAndSettle();
    var incrementButton = find.byIcon(AppIcons.plus);
    await tester.tap(incrementButton);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Decrement button decrements TextValue by one', (tester) async {
    await tester.pumpWidget(NumberInputDialogWrapper(
      value: 5,
    ));
    await tester.pumpAndSettle();
    var decrementButton = find.byIcon(AppIcons.minus);
    await tester.tap(decrementButton);
    expect(find.text('4'), findsOneWidget);
    await tester.tap(decrementButton);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Value is avare of its bounds', (tester) async {
    await tester.pumpWidget(NumberInputDialogWrapper(
      value: 0,
      minValue: 0,
      maxValue: 1,
    ));
    await tester.pumpAndSettle();

    var decrementButton = find.byIcon(AppIcons.minus);
    await tester.tap(decrementButton);
    expect(find.text('0'), findsOneWidget);

    var incrementButton = find.byIcon(AppIcons.plus);
    await tester.tap(incrementButton);
    await tester.tap(incrementButton);
    expect(find.text('1'), findsOneWidget);

    var textField = find.byType(TextField);
    await tester.enterText(textField, '2');
    expect(find.text('1'), findsOneWidget);
    await tester.enterText(textField, '-1');
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Custom Validation promts error If string is returned', (tester) async {
    await tester
        .pumpWidget(NumberInputDialogWrapper(value: 2, onValidation: (value) => value == 2 ? 'Custom Error' : null));
    await tester.pumpAndSettle();
    var okButton = find.text(AffLocalizer.instance.ok);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    expect(find.text('Custom Error'), findsOneWidget);
  });
}

class NumberInputDialogWrapper extends StatelessWidget {
  NumberInputDialogWrapper({this.value = 0, this.maxValue, this.minValue, this.onValidation});

  final num value;
  final num minValue;
  final num maxValue;
  final String Function(num) onValidation;

  @override
  Widget build(BuildContext context) {
    return TestApp(
        child: NumberInputDialog(
      title: Text(
        'Enter Qty',
        textAlign: TextAlign.center,
      ),
      value: value,
      minValue: minValue,
      maxValue: maxValue,
      onValidation: onValidation,
    ));
  }
}
