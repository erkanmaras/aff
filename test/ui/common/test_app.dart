import 'package:aff/src/infrastructure/l10n/aff_localizer.dart';
import 'package:aff/src/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TestApp extends StatelessWidget {
  const TestApp({this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [..._providers()],
        child: MaterialApp(
            builder: _builder,
            localizationsDelegates: _localizationsDelegates(),
            supportedLocales: _supportedLocales(),
            title: 'TestApp',
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(body: child);
              },
            )));
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = Provider.of<AppTheme>(context);
    if (!theme.initialized) {
      theme.setTheme(buildDefaultTheme(context));
    }

    return Theme(data: theme.data, child: child);
  }

  List<SingleChildWidget> _providers() {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(create: (context) => AppTheme()),
    ];
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [
      AffLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ];
  }

  Iterable<Locale> _supportedLocales() {
    return [const Locale('en'), const Locale('tr')];
  }
}
