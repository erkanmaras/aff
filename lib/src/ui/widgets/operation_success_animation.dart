import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';
class OperationSuccessAnimation extends StatefulWidget {
  @override
  _OperationSuccessAnimationState createState() =>
      _OperationSuccessAnimationState();
}

class _OperationSuccessAnimationState extends State<OperationSuccessAnimation>
    with SingleTickerProviderStateMixin {
  AppTheme appTheme;
  AnimationController _animationController;
  Animation<double> doneTween;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 777),
      reverseDuration: const Duration(milliseconds: 444),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });

    doneTween = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1, curve: Curves.easeInOut),
    ));
    _animationController.forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: doneTween,
        builder: (BuildContext context, Widget child) {
          double tweenValue = doneTween.value;
          return GestureDetector(
            onDoubleTap: () {
              _animationController.reset();
              _animationController.forward();
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xff8ade98),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.grey[400],
                        blurRadius: max<double>(10 * tweenValue, 2),
                        spreadRadius: max<double>(4 * tweenValue, 0.5))
                  ]),
              child: Container(
                height: 125 + (50 * tweenValue),
                width: 125 + (50 * tweenValue),
                decoration: BoxDecoration(
                  color: appTheme.colors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 110 + (50 * tweenValue),
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
