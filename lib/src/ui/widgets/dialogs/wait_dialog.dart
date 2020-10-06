import 'package:aff/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';
typedef WaitableFunction<T> = T Function(WaitDialog scope);

/// Sample Usage
/// try {
///   wait.show();
///   await Future.delayed(Duration(seconds: 3));
///   wait.update('messageText');
///   await Future.delayed(Duration(seconds: 3));
/// } finally {
///   wait.hide();
/// }

class WaitDialog {
  WaitDialog(this.context);
  BuildContext context;

  WaitDialogMessage dialogMessage;

  void show([String messageText, TextStyle messageTextStyle]) {
    if (dialogMessage?.isShowing ?? false) {
      if (dialogMessage.messageText != messageText) {
        update(messageText, messageTextStyle);
      }
      return;
    }

    dialogMessage = WaitDialogMessage();
    dialogMessage.isShowing = true;
    dialogMessage.messageText = messageText;
    dialogMessage.messageStyle = messageTextStyle;

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: _WaitDialogBody(dialogMessage));
        });
  }

  void update(String messageText, [TextStyle messageTextStyle]) {
    if (dialogMessage == null || !dialogMessage.isShowing) {
      return;
    }

    if ((messageText != null && dialogMessage.messageText != messageText) ||
        (messageTextStyle != null &&
            dialogMessage.messageStyle == messageTextStyle)) {
      dialogMessage.messageText = messageText;
      dialogMessage.messageStyle = messageTextStyle;

      dialogMessage.notifyListeners();
    }
  }

  bool hide() {
    if (dialogMessage == null || !dialogMessage.isShowing) {
      return true;
    }
    try {
      dialogMessage.isShowing = false;
      Navigator.of(context).pop(true);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  bool get isShowing {
    return dialogMessage?.isShowing ?? false;
  }

  static Future<T> scope<T>({
    @required BuildContext context,
    @required WaitableFunction<Future<T>> call,
    String waitMessage,
  }) async {
    T result;
    var wait = WaitDialog(context);
    try {
      wait.show(waitMessage ?? AffLocalizer.of(context).loading);
      result = await call(wait);
    } finally {
      wait.hide();
    }
    return result;
  }
}

class _WaitDialogBody extends StatefulWidget {
  _WaitDialogBody(this.dialogMessage);

  final _WaitDialogBodyState _state = _WaitDialogBodyState();
  final WaitDialogMessage dialogMessage;

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class _WaitDialogBodyState extends State<_WaitDialogBody> {
  void _update() {
    setState(() {});
  }

  @override
  void initState() {
    widget.dialogMessage.addListener(_update);
    super.initState();
  }

  @override
  void didUpdateWidget(_WaitDialogBody oldWidget) {
    oldWidget.dialogMessage.removeListener(_update);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.dialogMessage.isShowing = false;
    widget.dialogMessage.dispose();
    super.dispose();
  }

  static const RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)));
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = context.getMediaQuery();
    var appTheme = context.getTheme();
    var localizer = context.getLocalizer();
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      duration: const Duration(milliseconds: 100),
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Material(
            color: appTheme.data.primaryColor,
            shape: shape,
            type: MaterialType.card,
            child: Container(
              width: mediaQueryData.size.width,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.loose(Size(mediaQueryData.size.width, 110)),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: WidgetFactory.circularProgressIndicator(
                        color: appTheme.data.colorScheme.onPrimary),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              widget.dialogMessage.messageText ??
                                  localizer.loading,
                              textAlign: TextAlign.justify,
                              style: widget.dialogMessage.messageStyle ??
                                  appTheme.textStyles.bodyBold.copyWith(
                                      color: appTheme
                                          .data.colorScheme.onPrimary))))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaitDialogMessage extends ChangeNotifier {
  bool isShowing = false;
  String messageText;
  TextStyle messageStyle;

  @override
// ignore:unnecessary_overrides
  void notifyListeners() {
    super.notifyListeners();
  }
}
