import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

typedef Widget InnerWidgetBuilder(double value);
typedef String PercentageModifier(double value);

class CircularIndicator extends StatefulWidget {
  const CircularIndicator(
      {Key key,
      this.initialValue = 50,
      this.min = 0,
      this.max = 100,
      this.appearance = defaultAppearance,
      this.innerWidgetBuilder})
      : assert(initialValue != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(initialValue >= min && initialValue <= max),
        assert(appearance != null),
        super(key: key);

  final double initialValue;
  final double min;
  final double max;
  final CircularIndicatorAppearance appearance;
  final InnerWidgetBuilder innerWidgetBuilder;
  static const defaultAppearance = CircularIndicatorAppearance();

  double get angle {
    return _CircularIndicatorUtils.valueToAngle(initialValue, min, max, appearance.angleRange);
  }

  @override
  _CircularIndicatorState createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> with SingleTickerProviderStateMixin {
  _CircularIndicatorCurvePainter _painter;
  double _oldWidgetAngle;
  double _oldWidgetValue;
  double _currentAngle;
  double _selectedAngle;
  bool _animationCompleted = false;

  Animation<double> _animation;
  AnimationController _animController;

  @override
  void initState() {
    if (!widget.appearance.animationEnabled) {
      return;
    }
    _animController = AnimationController(vsync: this);
    _animate();
    super.initState();
  }

  @override
  void didUpdateWidget(CircularIndicator oldWidget) {
    if (oldWidget.angle != widget.angle) {
      _animate();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _animate() {
    if (!widget.appearance.animationEnabled || _animController == null) {
      _setupPainter();
      return;
    }

    _animationCompleted = false;

    final duration = _CircularIndicatorUtils.valueToDuration(
        widget.initialValue, _oldWidgetValue ?? widget.min, widget.min, widget.max);

    _animController.duration = Duration(milliseconds: duration);

    final curvedAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animation = Tween<double>(begin: _oldWidgetAngle ?? 0, end: widget.angle).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          if (!_animationCompleted && mounted) {
            _currentAngle = _animation.value;
            // update painter and the on change closure
            _setupPainter();
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationCompleted = true;

          _animController.reset();
          // _animController.dispose();
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
      child: Container(width: widget.appearance.size, height: widget.appearance.size, child: _buildChildWidget()),
    ));
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  void _setupPainter() {
    var defaultAngle = _currentAngle ?? widget.angle;
    if (_oldWidgetAngle != null) {
      if (_oldWidgetAngle != widget.angle) {
        _selectedAngle = null;
        defaultAngle = widget.angle;
      }
    }

    _currentAngle = _CircularIndicatorUtils.calculateAngle(
        startAngle: widget.appearance.startAngle,
        angleRange: widget.appearance.angleRange,
        selectedAngle: _selectedAngle,
        previousAngle: _currentAngle,
        defaultAngle: defaultAngle);

    _painter = _CircularIndicatorCurvePainter(
      angle: _currentAngle < 0.5 ? 0.5 : _currentAngle,
      appearance: widget.appearance,
    );
    _oldWidgetAngle = widget.angle;
    _oldWidgetValue = widget.initialValue;
  }

  Widget _buildChildWidget() {
    final value =
        _CircularIndicatorUtils.angleToValue(_currentAngle, widget.min, widget.max, widget.appearance.angleRange);
    final childWidget = widget.innerWidgetBuilder != null
        ? widget.innerWidgetBuilder(value)
        : CircularIndicatorLabel(
            value: value,
            appearance: widget.appearance,
          );
    return childWidget;
  }
}

class CircularIndicatorLabel extends StatelessWidget {
  const CircularIndicatorLabel({Key key, this.value, this.appearance}) : super(key: key);
  final double value;
  final CircularIndicatorAppearance appearance;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: builtInfo(appearance),
    );
  }

  List<Widget> builtInfo(CircularIndicatorAppearance appearance) {
    var widgets = <Widget>[];
    if (appearance.infoTopLabelText != null) {
      widgets.add(Text(
        appearance.infoTopLabelText,
        style: appearance.infoTopLabelStyle,
      ));
    }
    final modifier = appearance.infoModifier(value);
    widgets.add(
      Text('$modifier', style: appearance.infoMainLabelStyle),
    );
    if (appearance.infoBottomLabelText != null) {
      widgets.add(Text(
        appearance.infoBottomLabelText,
        style: appearance.infoBottomLabelStyle,
      ));
    }
    return widgets;
  }
}

class CircularIndicatorAppearance {
  const CircularIndicatorAppearance(
      {this.customColors,
      this.size = _defaultSize,
      this.trackWidth,
      this.progressBarWidth,
      this.shadowWidth,
      this.startAngle = _defaultStartAngle,
      this.angleRange = _defaultAngleRange,
      this.infoProperties,
      this.animationEnabled = true});

  static const double _defaultSize = 150;
  static const double _defaultStartAngle = 150;
  static const double _defaultAngleRange = 240;
  static const Color _defaultTrackColor = Color.fromRGBO(220, 190, 251, 1);

  static const List<Color> _defaultBarColors = [
    Color.fromRGBO(30, 0, 59, 1),
    Color.fromRGBO(236, 0, 138, 1),
    Color.fromRGBO(98, 133, 218, 1),
  ];

  static const double _defaultGradientStartAngle = 0;
  static const double _defaultGradientEndAngle = 180;
  static const bool _defaultHideShadow = false;
  static const Color _defaultShadowColor = Color.fromRGBO(44, 87, 192, 1);
  static const double _defaultShadowMaxOpacity = 0.2;

  String _defaultPercentageModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue %';
  }

  final double size;
  final double startAngle;
  final double angleRange;
  final bool animationEnabled;
  final double trackWidth;
  final double progressBarWidth;
  final double shadowWidth;

  final CircularIndicatorColors customColors;
  final CircularIndicatorInfoProperties infoProperties;

  double get trackSize => trackWidth ?? progressBarSize / 4;
  double get progressBarSize => progressBarWidth ?? size / 10;
  double get shadowSize => shadowWidth ?? progressBarSize * 1.4;

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

  double get _gradientStartAngle => customColors?.gradientStartAngle;

  double get _gradientEndAngle => customColors?.gradientEndAngle;

  Color get _customShadowColor => customColors?.shadowColor;

  double get _customShadowMaxOpacity => customColors?.shadowMaxOpacity;

  double get _customShadowStep => customColors?.shadowStep;

  bool get _hideShadow => customColors?.hideShadow;

  Color get trackColor => _customTrackColor ?? _defaultTrackColor;

  List<Color> get progressBarColors => _customProgressBarColors ?? _defaultBarColors;

  double get gradientStartAngle => _gradientStartAngle ?? _defaultGradientStartAngle;

  double get gradientStopAngle => _gradientEndAngle ?? _defaultGradientEndAngle;

  bool get hideShadow => _hideShadow ?? _defaultHideShadow;

  Color get shadowColor => _customShadowColor ?? _defaultShadowColor;

  double get shadowMaxOpacity => _customShadowMaxOpacity ?? _defaultShadowMaxOpacity;

  double get shadowStep => _customShadowStep;

  String get _topLabelText => infoProperties?.topLabelText;

  String get _bottomLabelText => infoProperties?.bottomLabelText;

  TextStyle get _mainLabelStyle => infoProperties?.mainLabelStyle;

  TextStyle get _topLabelStyle => infoProperties?.topLabelStyle;

  TextStyle get _bottomLabelStyle => infoProperties?.bottomLabelStyle;

  PercentageModifier get _modifier => infoProperties?.modifier;

  PercentageModifier get infoModifier => _modifier ?? _defaultPercentageModifier;

  String get infoTopLabelText => _topLabelText ?? '';

  String get infoBottomLabelText => _bottomLabelText ?? '';

  TextStyle get infoMainLabelStyle {
    if (_mainLabelStyle != null) {
      return _mainLabelStyle;
    }

    return TextStyle(fontWeight: FontWeight.w100, fontSize: size / 5, color: Color.fromRGBO(30, 0, 59, 1));
  }

  TextStyle get infoTopLabelStyle {
    if (_topLabelStyle != null) {
      return _topLabelStyle;
    }
    return TextStyle(fontWeight: FontWeight.w600, fontSize: size / 10, color: Color.fromRGBO(147, 81, 120, 1));
  }

  TextStyle get infoBottomLabelStyle {
    if (_bottomLabelStyle != null) {
      return _bottomLabelStyle;
    }
    return TextStyle(fontWeight: FontWeight.w600, fontSize: size / 10, color: Color.fromRGBO(147, 81, 120, 1));
  }
}

class CircularIndicatorColors {
  CircularIndicatorColors({
    this.trackColor,
    this.progressBarColor,
    this.progressBarColors,
    this.gradientStartAngle,
    this.gradientEndAngle,
    this.hideShadow,
    this.shadowColor,
    this.shadowMaxOpacity,
    this.shadowStep,
  });

  final Color trackColor;
  final Color progressBarColor;
  final List<Color> progressBarColors;
  final double gradientStartAngle;
  final double gradientEndAngle;
  final bool hideShadow;
  final Color shadowColor;
  final double shadowMaxOpacity;
  final double shadowStep;
}

class CircularIndicatorInfoProperties {
  CircularIndicatorInfoProperties({
    this.topLabelText,
    this.bottomLabelText,
    this.mainLabelStyle,
    this.topLabelStyle,
    this.bottomLabelStyle,
    this.modifier,
  });

  final PercentageModifier modifier;
  final TextStyle mainLabelStyle;
  final TextStyle topLabelStyle;
  final TextStyle bottomLabelStyle;
  final String topLabelText;
  final String bottomLabelText;
}

class _CircularIndicatorCurvePainter extends CustomPainter {
  _CircularIndicatorCurvePainter({this.appearance, this.angle = 30});

  final double angle;
  final CircularIndicatorAppearance appearance;

  Offset center;
  double radius;

  @override
  void paint(Canvas canvas, Size size) {
    radius = math.min(size.width / 2, size.height / 2) - appearance.progressBarSize * 0.5;
    center = Offset(size.width / 2, size.height / 2);

    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = appearance.trackSize
      ..color = appearance.trackColor;
    drawCircularArc(canvas: canvas, size: size, paint: trackPaint, ignoreAngle: true);

    if (!appearance.hideShadow) {
      drawShadow(canvas: canvas, size: size);
    }

    final progressBarRect = Rect.fromLTWH(0, 0, size.width, size.width);
    final progressBarGradient = SweepGradient(
      startAngle: _CircularIndicatorUtils.degreeToRadians(appearance.gradientStartAngle),
      endAngle: _CircularIndicatorUtils.degreeToRadians(appearance.gradientStopAngle),
      tileMode: TileMode.mirror,
      colors: appearance.progressBarColors,
    );

    final progressBarPaint = Paint()
      ..shader = progressBarGradient.createShader(progressBarRect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = appearance.progressBarSize;
    drawCircularArc(canvas: canvas, size: size, paint: progressBarPaint);
  }

  void drawCircularArc(
      {@required Canvas canvas, @required Size size, @required Paint paint, bool ignoreAngle = false}) {
    final double angleValue = ignoreAngle ? 0 : (appearance.angleRange - angle);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _CircularIndicatorUtils.degreeToRadians(appearance.startAngle),
        _CircularIndicatorUtils.degreeToRadians(appearance.angleRange - angleValue),
        false,
        paint);
  }

  void drawShadow({@required Canvas canvas, @required Size size}) {
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
      drawCircularArc(canvas: canvas, size: size, paint: shadowPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularIndicatorCurvePainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

class _CircularIndicatorUtils {
  static double degreeToRadians(double degree) {
    return (math.pi / 180) * degree;
  }

  static double radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  static double calculateAngle(
      {@required double startAngle,
      @required double angleRange,
      @required double selectedAngle,
      @required double previousAngle,
      @required double defaultAngle}) {
    if (selectedAngle == null) {
      return defaultAngle;
      // return previousAngle ?? defaultAngle;
    }

    double angle = radiansToDegrees(selectedAngle);

    if (angle >= startAngle && angle <= angleRange + startAngle) {
      return angle - startAngle;
    } else if (angle <= (startAngle + angleRange) - 360.0) {
      return 360.0 - startAngle + angle;
    } else if (angle > (startAngle + angleRange) - 360) {
      return previousAngle >= angleRange / 2.0 ? angleRange : 0.0;
    }
    return previousAngle;
  }

  static int valueToDuration(double value, double previous, double min, double max) {
    if (value == 0) {
      return 0;
    }
    final divider = (max - min) / 100;
    return (value - previous).abs() ~/ divider * 15;
  }

  static double valueToPercentage(double value, double min, double max) {
    if (value == 0) {
      return 0;
    }
    return value / ((max - min) / 100);
  }

  static double valueToAngle(double value, double min, double max, double angleRange) {
    return percentageToAngle(valueToPercentage(value - min, min, max), angleRange);
  }

  static double percentageToValue(double percentage, double min, double max) {
    if (percentage == 0) {
      return 0;
    }
    return ((max - min) / 100) * percentage + min;
  }

  static double percentageToAngle(double percentage, double angleRange) {
    if (percentage == 0) {
      return 0;
    }
    final step = angleRange / 100;
    if (percentage > 100) {
      return angleRange;
    } else if (percentage < 0) {
      return 0.5;
    }
    return percentage * step;
  }

  static double angleToValue(double angle, double min, double max, double angleRange) {
    return percentageToValue(angleToPercentage(angle, angleRange), min, max);
  }

  static double angleToPercentage(double angle, double angleRange) {
    if (angle == 0) {
      return 0;
    }
    final step = angleRange / 100;
    if (angle > angleRange) {
      return 100;
    } else if (angle < 0.5) {
      return 0;
    }
    return angle / step;
  }
}
