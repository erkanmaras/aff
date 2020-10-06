import 'package:aff/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common/test_app.dart';

void main() {
  group('ExpandedRow', () {
    testWidgets('wrap children with expanded widget', (tester) async {
      await tester.pumpWidget(TestApp(
          child: ExpandedRow(
        children: <Widget>[
          Text('Value1'),
          Text('Value2'),
        ],
      )));
      await tester.pumpAndSettle();
      final expanded1 = find.widgetWithText(Expanded, 'Value1');
      expect(expanded1, findsOneWidget);
      final expanded2 = find.widgetWithText(Expanded, 'Value2');
      expect(expanded2, findsOneWidget);
    });

    testWidgets('not wraps children if allready in expanded widget', (tester) async {
      await tester.pumpWidget(TestApp(
          child: ExpandedRow(
        children: <Widget>[
          Expanded(child: Text('Value1')),
        ],
      )));
      await tester.pumpAndSettle();
      final expanded1 = find.byType(Expanded);
      expect(expanded1, findsOneWidget);
    });
  });

  group('ExpandedColumn', () {
    testWidgets('wraps child with expanded widget', (tester) async {
      await tester.pumpWidget(TestApp(
          child: ExpandedColumn(
        children: <Widget>[
          Text('Value1'),
          Text('Value2'),
        ],
      )));
      await tester.pumpAndSettle();
      final expanded1 = find.widgetWithText(Expanded, 'Value1');
      expect(expanded1, findsOneWidget);
      final expanded2 = find.widgetWithText(Expanded, 'Value2');
      expect(expanded2, findsOneWidget);
    });

    testWidgets('not wraps child if allready in expanded widget', (tester) async {
      await tester.pumpWidget(TestApp(
          child: ExpandedColumn(
        children: <Widget>[
          Expanded(child: Text('Value1')),
        ],
      )));
      await tester.pumpAndSettle();
      final expanded1 = find.byType(Expanded);
      expect(expanded1, findsOneWidget);
    });
  });
}
