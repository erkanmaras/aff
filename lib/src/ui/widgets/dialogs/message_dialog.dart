
import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
 
List<Widget> _createDialogButtons(
  BuildContext context,
  DialogButton buttons,
  Color textColor,
) {
  var localizer = AffLocalizer.of(context);

  return [
    if (buttons.index == DialogButton.yesNoCancel.index)
      TextButton(
          style: TextButton.styleFrom(primary: textColor),
          onPressed: () {
            Navigator.pop(context, DialogResult.cancel);
          },
          child: Text(localizer.cancel)),
    if (buttons.index == DialogButton.yesNo.index ||
        buttons.index == DialogButton.yesNoCancel.index)
      TextButton(
          style: TextButton.styleFrom(primary: textColor),
          onPressed: () {
            Navigator.pop(context, DialogResult.no);
          },
          child: Text(localizer.no)),
    if (buttons.index == DialogButton.yesNo.index ||
        buttons.index == DialogButton.yesNoCancel.index)
      TextButton(
          style: TextButton.styleFrom(primary: textColor),
          onPressed: () {
            Navigator.pop(context, DialogResult.yes);
          },
          child: Text(localizer.yes)),
    if (buttons == DialogButton.ok)
      TextButton(
          style: TextButton.styleFrom(primary: textColor),
          onPressed: () {
            Navigator.pop(context, DialogResult.ok);
          },
          child: Text(localizer.ok)),
  ];
}

class MessageDialog {
  static Future<DialogResult> error({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    return _show(
      context,
      title ?? AffLocalizer.of(context).error,
      message,
      buttons: buttons,
      color: context.getTheme().colors.error,
    );
  }

  static Future<DialogResult> warning({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    return _show(
      context,
      title ?? AffLocalizer.of(context).warning,
      message,
      buttons: buttons,
      color: context.getTheme().colors.warning,
    );
  }

  static Future<DialogResult> info({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    return _show(
      context,
      title ?? AffLocalizer.of(context).information,
      message,
      buttons: buttons,
      color: context.getTheme().colors.info,
    );
  }

  static Future<DialogResult> question({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    return _show(
      context,
      title ?? AffLocalizer.of(context).question,
      message,
      buttons: buttons,
      color: context.getTheme().colors.primary,
    );
  }

  static Future<DialogResult> message({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    buttons ??= DialogButton.ok;
    return _show(
      context,
      title,
      message,
      buttons: buttons,
    );
  }

  static Future<DialogResult> _show(
    BuildContext context,
    String title,
    String message, {
    DialogButton buttons,
    Color color,
  }) async {
    assert(message != null);
    final appTheme = context.getTheme();
    buttons ??= DialogButton.ok;
    var titleTextStyle = appTheme.textStyles.subtitleBold;
    color ??= appTheme.colors.primary;
    var result = await showDialog<DialogResult>(
        barrierDismissible: buttons == DialogButton.ok,
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.symmetric(horizontal: 0),
            titleTextStyle: titleTextStyle,
            title: title.isNullOrEmpty()
                ? SizedBox(
                    height: kMinInteractiveDimension / 2,
                  )
                : Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            title ?? '',
                            style: titleTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IndentDivider(
                        thickness: 1,
                        color: color,
                      )
                    ],
                  ),
            content: SingleChildScrollView(
                child: Center(child: Text(message ?? ''))),
            actions: _createDialogButtons(context, buttons, color),
          );
        });
    return result ?? DialogResult.cancel;
  }
}

class MessageSheet {
  static Future<DialogResult> error({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    final appTheme = context.getTheme();
    return _show(context, title ?? AffLocalizer.of(context).error, message,
        buttons: buttons,
        color: appTheme.colors.error,
        icon: AppIcons.alertCircleOutline);
  }

  static Future<DialogResult> warning({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    final appTheme = context.getTheme();
    return _show(context, title ?? context.getLocalizer().warning, message,
        buttons: buttons,
        color: appTheme.colors.warning,
        icon: AppIcons.alertOutline);
  }

  static Future<DialogResult> info({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    final appTheme = context.getTheme();
    return _show(context, title ?? context.getLocalizer().information, message,
        buttons: buttons,
        color: appTheme.colors.info,
        icon: AppIcons.informationOutline);
  }

  static Future<DialogResult> question({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
  }) async {
    final appTheme = context.getTheme();
    return _show(context, title ?? context.getLocalizer().question, message,
        buttons: buttons,
        color: appTheme.colors.info,
        icon: AppIcons.helpCircleOutline);
  }

  static Future<DialogResult> message({
    @required BuildContext context,
    @required String message,
    String title,
    DialogButton buttons,
    IconData icon,
  }) async {
    icon ??= AppIcons.messageOutline;
    final appTheme = context.getTheme();
    return _show(context, title ?? context.getLocalizer().message, message,
        buttons: buttons,
        color: appTheme.colors.primary,
        icon: AppIcons.messageOutline);
  }

  static Future<DialogResult> _show(
    BuildContext context,
    String title,
    String message, {
    DialogButton buttons,
    Color color,
    IconData icon,
  }) async {
    buttons ??= DialogButton.ok;
    var result = await showModalBottomSheet<DialogResult>(
      context: context,
      enableDrag: buttons == DialogButton.ok,
      isScrollControlled: true,
      isDismissible: buttons == DialogButton.ok,
      builder: (BuildContext context) {
        final appTheme = context.getTheme();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: appTheme.textStyles.title
                        .copyWith(color: appTheme.colors.fontLight),
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SingleChildScrollView(
                      child: icon != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    message,
                                    style: appTheme.textStyles.bodyBold
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Icon(
                                  icon,
                                  size: 52,
                                  color: Colors.white,
                                )
                              ],
                            )
                          : Text(
                              message,
                              style: appTheme.textStyles.bodyBold
                                  .copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: appTheme.colors.darken(color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _createDialogButtons(context, buttons, Colors.white),
              ),
            )
          ],
        );
      },
    );
    return result ?? DialogResult.cancel;
  }
}
