import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension BuildContextExtensions on BuildContext {
  T get<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
  AffLocalizer getLocalizer() => AffLocalizer.of(this);
  AppTheme getTheme({bool listen = false}) =>
      Provider.of<AppTheme>(this, listen: listen);
  FocusScopeNode getFocusScope() => FocusScope.of(this);
  MediaQueryData getMediaQuery({bool nullOk = false}) =>
      MediaQuery.of(this, nullOk: nullOk);
}
