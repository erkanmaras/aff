import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';
class ProgressButton extends StatefulWidget {
  ProgressButton({@required this.child, @required this.onPressed, this.color});

  /// The background color of the button.
  final Color color;

  /// Function that will be called at the on pressed event.
  final Function(VoidCallback startProgressing, VoidCallback stopProgressing,
      bool isProgressing) onPressed;

  /// The child to display on the button.
  final Widget child;

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool progressing = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && mounted) {
        setState(() {
          progressing = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startProgressing() {
    setState(() {
      progressing = true;
    });
    _controller.forward();
  }

  void stopProgressing() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: LayoutBuilder(builder: _progressAnimatedBuilder));
  }

  AnimatedBuilder _progressAnimatedBuilder(
      BuildContext context, BoxConstraints constraints) {
    var buttonHeight = (constraints.maxHeight != double.infinity)
        ? constraints.maxHeight
        : context.getTheme().data.buttonTheme.height;
    var widthAnimation = Tween<double>(
      begin: constraints.maxWidth,
      end: buttonHeight * 2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    var borderRadiusAnimation = Tween<BorderRadius>(
      
      begin: context.getTheme().data.buttonBorderRadius(),
      end: BorderRadius.all(Radius.circular(buttonHeight / 2.0)),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: buttonHeight,
          width: widthAnimation.value,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: widget.color,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadiusAnimation.value,
                ),
              ),
              onPressed: () {
                widget.onPressed(
                    startProgressing, stopProgressing, progressing);
              },
              child: progressing
                  ? WidgetFactory.dotProgressIndicator(size: buttonHeight / 2)
                  : widget.child),
        );
      },
    );
  }
}
