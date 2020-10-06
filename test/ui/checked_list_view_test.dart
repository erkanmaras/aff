import 'package:aff/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common/test_app.dart';

void main() {
  group('CheckedListView', () {
    final checkedList = {'Value1': false, 'Value2': false};

    testWidgets('build correct type and count list item', (tester) async {
      await tester.pumpWidget(TestApp(
          child: CheckedListView(
        itemBuilder: (BuildContext context,String value) {
          return Text(value);
        },
        list: checkedList,
      )));
      await tester.pumpAndSettle();
      
      final listItemValue1 = find.text('Value1');
      expect(listItemValue1, findsOneWidget);

      final listItemValue2 = find.text('Value2');
      expect(listItemValue2, findsOneWidget);
    });

    testWidgets('must check list item when longPress and uncheck when tab', (tester) async {
      await tester.pumpWidget(TestApp(
          child: CheckedListView(
        itemBuilder: (BuildContext context,String value) {
          return Text(value);
        },
        list: checkedList,
      )));
      await tester.pumpAndSettle();

      var inkwell = find.widgetWithText(InkWell, 'Value1');
      await tester.longPress(inkwell);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(inkwell);
      await tester.pump();
      expect(checkedList.values.any((value) => value), isFalse);
    });

    testWidgets('must call onTab callback with correct value', (tester) async {
      String tabedVaue = '';
      await tester.pumpWidget(TestApp(
          child: CheckedListView(
        itemBuilder: (BuildContext context,String value) {
          return Text(value);
        },
        list: checkedList,
        onTab: (String value) {
          tabedVaue = value;
        },
      )));
      await tester.pumpAndSettle();

      var inkwell = find.widgetWithText(InkWell, 'Value1');
      await tester.tap(inkwell);
      await tester.pump();
      expect(tabedVaue, equals('Value1'));
    });

    testWidgets('must call onTabTargetChanged with true when longPress', (tester) async {
      // Todo(erkan):  back butonu ile false a çekildiği test edilmeli.
      // tester.pageBack() hata veriyor.
      bool checkMode = false;
      await tester.pumpWidget(TestApp(
          child: CheckedListView(
        itemBuilder: (BuildContext context,String value) {
          return Text(value);
        },
        list: checkedList,
        onTabTargetChanged: (value) {
          checkMode = true;
        },
      )));
      await tester.pumpAndSettle();

      var inkwell = find.widgetWithText(InkWell, 'Value1');
      await tester.longPress(inkwell);
      await tester.pump();
      expect(checkMode, isTrue);
    });
  });
}
