import 'package:aff/src/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';

class DefaultThemeColors extends IAppColors {
  //primartPale 0xffE8F0FE
  @override
  Color get accent => Color(0xff03469f); //0xff003F8C
  @override
  Color get canvasDark => Color(0xffE5E5E5);
  @override
  Color get canvas => Color(0xffF1F3F4); //F8F6F6 , F2F2F2
  @override
  Color get canvasLight => Color(0xffffffff);
  @override
  Color get disabled => fontPale.lighten(0.5);
  @override
  Color get divider => Color(0xffDADCE0);
  @override
  Color get success => Color(0xff3dc954);
  @override
  Color get error => Color(0xfff54d53);
  @override
  Color get warning => Color(0xfffd791c);
  @override
  Color get info => primary;
  @override
  Color get font => Color(0xff5F6368);
  @override
  Color get fontPale => Color(0xff80868B);
  @override
  Color get fontLight => Color(0xffffffff);
  @override
  Color get primary => Color(0xff1a73e9);
  @override
  Color get primaryPale => primary.lighten(0.30);
  @override
  Color get unselectedWidgetColor => fontPale;
  @override
  Color get toggleableActiveColor => primary;
  @override
  Color get inputFillColor => Color(0xFFf2f6fd);
  //Inkwell
  @override
  Color get splash => Color(0xffa9cbf7).withOpacity(0.5);

  @override
  Color get highlight => Color(0xffa9cbf7).withOpacity(0.3);
}

class DefaultThemeTextStyles extends IAppTextStyles {
  DefaultThemeTextStyles(this.data, this.colors);
  ThemeData data;
  IAppColors colors;

  @override
  TextStyle get title => data.textTheme.headline6;

  @override
  TextStyle get subtitleBold => data.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w500);

  @override
  TextStyle get subtitle => data.textTheme.subtitle1;

  @override
  TextStyle get body => data.textTheme.bodyText2;

  @override
  TextStyle get bodyBold => data.textTheme.bodyText1;

  @override
  TextStyle get caption => data.textTheme.caption;

  @override
  TextStyle get overline => data.textTheme.overline;
}

AppThemeData buildDefaultTheme(BuildContext context, {IAppColors colors}) {
  //appbar spesific copy
  TextTheme _appBarTextTheme(
    TextTheme base,
    Color color,
    String fontFamily,
  ) {
    return ThemeUtils.textThemeCopyWith(base, color, fontFamily).copyWith(
      headline6: base.headline6.copyWith(
        color: color,
        fontSize: base.headline6.fontSize,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      ),
    );
  }

  var fontFamily = 'Roboto';
  var buttonBorderRadius = BorderRadius.circular(18);
  var textBorderRadius = BorderRadius.circular(18);
  var cardBorderRadius = BorderRadius.circular(4);
  var appColors = colors ?? DefaultThemeColors();
  var baseTheme = Theme.of(context);
  var newTheme = ThemeData(
    fontFamily: fontFamily,
    primaryColor: appColors.primary,
    primaryColorLight: appColors.primary,
    primaryColorDark: appColors.primary,
    primaryColorBrightness: Brightness.dark,
    accentColor: appColors.accent,
    accentColorBrightness: Brightness.dark,
    canvasColor: appColors.canvasLight,
    disabledColor: appColors.disabled,
    scaffoldBackgroundColor: appColors.canvas,
    highlightColor: appColors.highlight,
    splashColor: appColors.splash,
    dialogBackgroundColor: appColors.canvasLight,
    errorColor: appColors.error,
    indicatorColor: appColors.primary,
    cursorColor: appColors.primary,
    unselectedWidgetColor: appColors.unselectedWidgetColor,
    toggleableActiveColor: appColors.toggleableActiveColor,

    toggleButtonsTheme: ToggleButtonsThemeData(
      constraints: BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension * 0.8),
      borderRadius: buttonBorderRadius,
      color: appColors.font,
      selectedColor: appColors.primary,
      disabledColor: appColors.disabled,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 0.5,
    ),

    chipTheme: ChipThemeData.fromDefaults(
      labelStyle: baseTheme.textTheme.bodyText2,
      primaryColor: appColors.primary,
      secondaryColor: appColors.inputFillColor,
    ),
    textSelectionTheme: baseTheme.textSelectionTheme
        .copyWith(selectionHandleColor: appColors.primary, selectionColor: appColors.primary.lighten(0.8)),
    useTextSelectionTheme: true,
    popupMenuTheme: PopupMenuThemeData(elevation: 0.5),
    floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0.5),
    dividerTheme: DividerThemeData(color: appColors.divider, space: 1),
    tabBarTheme: TabBarTheme(
      labelColor: appColors.primary,
      unselectedLabelColor: appColors.primaryPale,
    ),

    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: appColors.primary),
      textTheme: _appBarTextTheme(baseTheme.primaryTextTheme, appColors.font, fontFamily),
      color: appColors.canvasLight,
      elevation: 0.5,
      brightness: Brightness.light,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: appColors.canvasLight,
      elevation: 1,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
    )),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
    )),
    //Text selection control hala bu temayı kullanıyor.
    buttonTheme: ButtonThemeData(
      buttonColor: appColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),

    cardTheme: CardTheme(
      color: appColors.canvasLight,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
    ),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: baseTheme.textTheme.bodyText2.copyWith(color: appColors.fontLight),
        backgroundColor: appColors.info,
        elevation: 4,
        actionTextColor: appColors.fontLight),

    textTheme: ThemeUtils.textThemeCopyWith(baseTheme.textTheme, appColors.font, fontFamily),
    primaryTextTheme: ThemeUtils.textThemeCopyWith(baseTheme.primaryTextTheme, appColors.fontLight, fontFamily),
    accentTextTheme: ThemeUtils.textThemeCopyWith(baseTheme.accentTextTheme, appColors.fontLight, fontFamily),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: appColors.font),
      hintStyle: TextStyle(color: appColors.fontPale.withOpacity(0.7)),
      helperStyle: TextStyle(color: appColors.fontPale),
      prefixStyle: TextStyle(color: appColors.fontPale),
      suffixStyle: TextStyle(color: appColors.fontPale),
      counterStyle: TextStyle(color: appColors.fontPale),
      errorStyle: TextStyle(color: appColors.error.withOpacity(0.7)),
      contentPadding: EdgeInsets.all(10),
      fillColor: Color(0xFFf2f6fd),
      filled: true,
      isDense: true,
      border: ThemeUtils.inputBorder(
        appColors.canvasDark,
        textBorderRadius,
      ),
      focusedBorder: ThemeUtils.inputBorder(
        appColors.primary.lighten(0.6),
        textBorderRadius,
      ),
      enabledBorder: ThemeUtils.inputBorder(
        appColors.canvasDark,
        textBorderRadius,
      ),
      errorBorder: ThemeUtils.inputBorder(
        appColors.error.lighten(0.7),
        textBorderRadius,
      ),
      focusedErrorBorder: ThemeUtils.inputBorder(
        appColors.error.lighten(0.5),
        textBorderRadius,
      ),
      disabledBorder: ThemeUtils.inputBorder(
        appColors.disabled,
        textBorderRadius,
      ),
    ),
    // snackBarTheme: baseTheme.snackBarTheme.copyWith(
    //     contentTextStyle: baseTheme.snackBarTheme.contentTextStyle
    //         .copyWith(color: appColors.fontDark)),
    colorScheme: ColorScheme(
      background: appColors.canvas,
      brightness: Brightness.light,
      error: appColors.error,
      primary: appColors.primary,
      primaryVariant: appColors.primary,
      secondary: appColors.accent,
      secondaryVariant: appColors.accent,
      surface: appColors.canvas,
      onBackground: appColors.font,
      onError: appColors.fontLight,
      onPrimary: appColors.fontLight,
      onSecondary: appColors.fontLight,
      onSurface: appColors.font,
    ),

    primaryIconTheme: IconThemeData(color: appColors.canvasLight),
    accentIconTheme: IconThemeData(color: appColors.canvasLight),
    iconTheme: IconThemeData(color: appColors.primary),
    //use cupertino slide effect
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );

  return AppThemeData(newTheme, appColors, DefaultThemeTextStyles(newTheme, appColors));
}
