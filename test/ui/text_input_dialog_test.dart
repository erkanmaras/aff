
import 'package:aff/infrastructure.dart';
import 'package:aff/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common/test_app.dart';

void main() {
  testWidgets('Can have an Initial Value', (tester) async {
    await tester.pumpWidget(TextInputDialogWrapper(value: 'foo'));
    await tester.pumpAndSettle();
    expect(find.text('foo'), findsOneWidget);
  });

  testWidgets('Custom Validation promts error If string is returned', (tester) async {
    await tester.pumpWidget(
        TextInputDialogWrapper(value: 'foo', onValidation: (value) => value == 'foo' ? 'Custom Error' : null));
    await tester.pumpAndSettle();
    var okButton = find.text(AffLocalizer.instance.ok);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    expect(find.text('Custom Error'), findsOneWidget);
  });
}

class TextInputDialogWrapper extends StatelessWidget {
  TextInputDialogWrapper({this.value, this.onValidation});

  final String value;
  final String Function(String) onValidation;

  @override
  Widget build(BuildContext context) {
    return TestApp(
        child: TextInputDialog(
      title: Text(
        'Miktarlı Giriş',
        textAlign: TextAlign.center,
      ),
      value: value,
      onValidation: onValidation,
    ));
  }
}
