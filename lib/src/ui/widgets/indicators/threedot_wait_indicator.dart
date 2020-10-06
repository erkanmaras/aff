import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';

class ThreeDotWaitIndicator extends StatefulWidget {
  ThreeDotWaitIndicator({
    this.color,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  _ThreeDotWaitIndicatorState createState() => _ThreeDotWaitIndicatorState();
}

class _ThreeDotWaitIndicatorState extends State<ThreeDotWaitIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  AppTheme appTheme;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    appTheme =  context.getTheme() ;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _circle(0, 0),
            _circle(1, .2),
            _circle(2, .4),
          ],
        ),
      ),
    );
  }

  Widget _circle(int index, double delay) {
    final _size = widget.size * 0.5;
    return ScaleTransition(
      scale: _DelayTween(begin: 0, end: 1, delay: delay).animate(_controller),
      child: SizedBox.fromSize(
        size: Size.square(_size),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.color ?? appTheme.colors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DelayTween extends Tween<double> {
  _DelayTween({double begin, double end, this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
