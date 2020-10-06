import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

class LinearIndicator extends StatefulWidget {
  const LinearIndicator({Key key, this.initialValue = 0.5, this.appearance = defaultAppearance})
      : assert(initialValue != null),
        assert(initialValue >= 0 && initialValue <= 1),
        assert(appearance != null),
        super(key: key);

  final double initialValue;

  final LinearIndicatorAppearance appearance;
  static const defaultAppearance = LinearIndicatorAppearance();

  @override
  _LinearIndicatorState createState() => _LinearIndicatorState();
}

class _LinearIndicatorState extends State<LinearIndicator> with SingleTickerProviderStateMixin {
  _LinearIndicatorCurvePainter _painter;

  double _oldWidgetValue;
  double _currentValue;
  bool _animationCompleted = false;

  Animation<double> _animation;
  AnimationController _animController;

  @override
  void initState() {
    super.initState();
    if (!widget.appearance.animationEnabled) {
      return;
    }
    _animController = AnimationController(vsync: this);
    _animate();
  }

  @override
  void didUpdateWidget(LinearIndicator oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _animate();
    }
    super.didUpdateWidget(oldWidget);
  }

  int valueToDuration(double value, double previous) {
    return ((value - previous).abs() * 1000).truncate();
  }

  void _animate() {
    if (!widget.appearance.animationEnabled || _animController == null) {
      _setupPainter();
      return;
    }

    _animationCompleted = false;

    final duration = valueToDuration(widget.initialValue, _oldWidgetValue ?? 0);

    _animController.duration = Duration(milliseconds: duration);

    final curvedAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          if (!_animationCompleted && mounted) {
            _currentValue = _animation.value * widget.initialValue;
            // update painter and the on change closure
            _setupPainter();
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationCompleted = true;

          _animController.reset();
        }
      });
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    /// If painter is null there is a need to setup it to prevent exceptions.
    if (_painter == null) {
      _setupPainter();
    }
    return Container(
        child: CustomPaint(
      painter: _painter,
      child: Container(width: widget.appearance.width, height: widget.appearance.progressBarSize),
    ));
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  void _setupPainter() {
    var defaultAngle = _currentValue ?? widget.initialValue;
    if (_oldWidgetValue != null) {
      if (_oldWidgetValue != widget.initialValue) {
        defaultAngle = widget.initialValue;
      }
    }
    _painter = _LinearIndicatorCurvePainter(value: defaultAngle, appearance: widget.appearance);
    _oldWidgetValue = widget.initialValue;
  }
}

class LinearIndicatorAppearance {
  const LinearIndicatorAppearance(
      {this.customColors,
      this.width = double.infinity,
      this.progressBarHeight,
      this.trackHeight,
      this.shadowHeight,
      this.animationEnabled = true});

  final double width;
  final bool animationEnabled;

  final LinearIndicatorColors customColors;
  final double trackHeight;
  final double progressBarHeight;
  final double shadowHeight;

  double get trackSize => trackHeight ?? progressBarSize / 4;
  double get progressBarSize => progressBarHeight ?? width / 10;
  double get shadowSize => shadowHeight ?? progressBarSize * 1.4;

  Color get _customTrackColor => customColors?.trackColor;
  List<Color> get _customProgressBarColors {
    if (customColors != null) {
      if (customColors.progressBarColors != null) {
        return customColors.progressBarColors;
      } else if (customColors.progressBarColor != null) {
        return [customColors.progressBarColor, customColors.progressBarColor];
      }
    }
    return null;
  }

  Color get _customShadowColor => customColors?.shadowColor;

  double get _customShadowMaxOpacity => customColors?.shadowMaxOpacity;

  double get _customShadowStep => customColors?.shadowStep;

  bool get _hideShadow => customColors?.hideShadow;

  Color get trackColor => _customTrackColor ?? Color.fromRGBO(220, 190, 251, 1);

  List<Color> get progressBarColors =>
      _customProgressBarColors ??
      [
        Color.fromRGBO(30, 0, 59, 1),
        Color.fromRGBO(236, 0, 138, 1),
        Color.fromRGBO(98, 133, 218, 1),
      ];

  bool get hideShadow => _hideShadow ?? false;

  Color get shadowColor => _customShadowColor ?? Color.fromRGBO(44, 87, 192, 1);

  double get shadowMaxOpacity => _customShadowMaxOpacity ?? 0.2;

  double get shadowStep => _customShadowStep;
}

// TODO(erkan):  progressBarColors yerine linear gradient alabilir.
// renk başlangıç ve bitişlerini ayarlayabilmek için
// shadow step ? gereksiz ise kaldırılacak.
class LinearIndicatorColors {
  LinearIndicatorColors({
    this.trackColor,
    this.progressBarColor,
    this.progressBarColors,
    this.hideShadow,
    this.shadowColor,
    this.shadowMaxOpacity,
    this.shadowStep,
  });

  final Color trackColor;
  final Color progressBarColor;
  final List<Color> progressBarColors;
  final bool hideShadow;
  final Color shadowColor;
  final double shadowMaxOpacity;
  final double shadowStep;
}

class _LinearIndicatorCurvePainter extends CustomPainter {
  _LinearIndicatorCurvePainter({this.appearance, this.value});

  final double value;
  final LinearIndicatorAppearance appearance;

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = appearance.trackSize
      ..color = appearance.trackColor;
    final halfHeight = size.height / 2;
    final start = Offset(0, halfHeight);
    final end = Offset(size.width, halfHeight);

    final progressValue = size.width * (value ?? 0);
    canvas.drawLine(start, end, trackPaint);

    if (!appearance.hideShadow) {
      final shadowStep = appearance?.shadowStep != null
          ? appearance.shadowStep
          : math.max(1, (appearance.shadowSize - appearance.progressBarSize) ~/ 10);
      final maxOpacity = math.min(1, appearance.shadowMaxOpacity);
      final repetitions = math.max(1, (appearance.shadowSize - appearance.progressBarSize) ~/ shadowStep);
      final opacityStep = maxOpacity / repetitions;
      final shadowPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (int i = 1; i <= repetitions; i++) {
        shadowPaint.strokeWidth = appearance.progressBarSize + i * shadowStep;
        shadowPaint.color = appearance.shadowColor.withOpacity(maxOpacity - (opacityStep * (i - 1)) as double);
        canvas.drawLine(start, Offset(progressValue, halfHeight), shadowPaint);
      }
    }

    final progressBarRect = Rect.fromLTWH(0, 0, size.width, size.width);
    final progressBarGradient = LinearGradient(
      tileMode: TileMode.mirror,
      colors: appearance.progressBarColors,
    );

    final progressBarPaint = Paint()
      ..shader = progressBarGradient.createShader(progressBarRect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = appearance.progressBarSize;

    canvas.drawLine(start, Offset(progressValue, halfHeight), progressBarPaint);
  }

  @override
  bool shouldRepaint(_LinearIndicatorCurvePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
