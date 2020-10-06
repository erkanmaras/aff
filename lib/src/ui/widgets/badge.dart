import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  Badge({
    Key key,
    this.badgeContent,
    this.child,
    this.badgeColor = Colors.red,
    this.elevation = 2,
    this.animate = true,
    this.position,
    this.shape = BadgeShape.circle,
    this.padding = const EdgeInsets.all(5),
    this.animationDuration = const Duration(milliseconds: 500),
    this.borderRadius,
    this.alignment = Alignment.center,
    this.animationType = BadgeAnimationType.slide,
    this.showBadge = true,
  }) : super(key: key);

  final Widget badgeContent;
  final Color badgeColor;
  final Widget child;
  final double elevation;
  final bool animate;
  final BadgePosition position;
  final BadgeShape shape;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final BadgeAnimationType animationType;
  final bool showBadge;

  @override
  BadgeState createState() {
    return BadgeState();
  }
}

class BadgeState extends State<Badge> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  final Tween<Offset> _positionTween = Tween(
    begin: const Offset(-0.5, 0.9),
    end: const Offset(0, 0),
  );
  final Tween<double> _scaleTween = Tween<double>(begin: 0.1, end: 1);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    if (widget.animationType == BadgeAnimationType.slide) {
      _animation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    } else if (widget.animationType == BadgeAnimationType.scale) {
      _animation = _scaleTween.animate(_animationController);
    } else if (widget.animationType == BadgeAnimationType.fade) {
      _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    }

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return _getBadge();
    } else {
      return Stack(
        alignment: widget.alignment,
        overflow: Overflow.visible,
        children: [
          widget.child,
          BadgePositioned(
            position: widget.position,
            child: _getBadge(),
          ),
        ],
      );
    }
  }

  Widget _getBadge() {
    MaterialType type;
    if (widget.shape == BadgeShape.circle) {
      type = MaterialType.circle;
    } else if (widget.shape == BadgeShape.square) {
      type = MaterialType.card;
    } else {
      type = MaterialType.card;
    }
    RoundedRectangleBorder border = type == MaterialType.circle
        ? null
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          );

    Widget badgeView() {
      return AnimatedOpacity(
        opacity: widget.showBadge ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Material(
          shape: border,
          type: type,
          elevation: widget.elevation,
          color: widget.badgeColor,
          child: Padding(
            padding: widget.padding,
            child: widget.badgeContent,
          ),
        ),
      );
    }

    if (widget.animate) {
      if (widget.animationType == BadgeAnimationType.slide) {
        return SlideTransition(
          position: _positionTween.animate(_animation),
          child: badgeView(),
        );
      } else if (widget.animationType == BadgeAnimationType.scale) {
        return ScaleTransition(
          scale: _animation,
          child: badgeView(),
        );
      } else if (widget.animationType == BadgeAnimationType.fade) {
        return FadeTransition(
          opacity: _animation,
          child: badgeView(),
        );
      }
    }

    return badgeView();
  }

  @override
  void didUpdateWidget(Badge oldWidget) {
    if (widget.badgeContent is Text && oldWidget.badgeContent is Text) {
      Text newText = widget.badgeContent as Text;
      Text oldText = oldWidget.badgeContent as Text;
      if (newText.data != oldText.data) {
        _animationController.reset();
        _animationController.forward();
      }
    }

    if (widget.badgeContent is Icon && oldWidget.badgeContent is Icon) {
      Icon newIcon = widget.badgeContent as Icon;
      Icon oldIcon = oldWidget.badgeContent as Icon;
      if (newIcon.icon != oldIcon.icon) {
        _animationController.reset();
        _animationController.forward();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum BadgeAnimationType { slide, scale, fade }
enum BadgeShape { circle, square }

class BadgePosition {
  const BadgePosition({this.top, this.end, this.bottom, this.start});

  factory BadgePosition.topStart({double top, double start}) {
    return BadgePosition(top: top ?? -5, start: start ?? -10);
  }

  factory BadgePosition.topEnd({double top, double end}) {
    return BadgePosition(top: top ?? -8, end: end ?? -10);
  }

  factory BadgePosition.bottomEnd({double bottom, double end}) {
    return BadgePosition(bottom: bottom ?? -8, end: end ?? -10);
  }

  factory BadgePosition.bottomStart({double bottom, double start}) {
    return BadgePosition(bottom: bottom ?? -8, start: start ?? -10);
  }

  final double top;
  final double end;
  final double bottom;
  final double start;
}

class BadgePositioned extends StatelessWidget {
  const BadgePositioned({Key key, this.position, this.child}) : super(key: key);

  final Widget child;
  final BadgePosition position;

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      final topRight = BadgePosition.topEnd();
      return PositionedDirectional(
        top: topRight.top,
        end: topRight.end,
        child: child,
      );
    }
    return PositionedDirectional(
      top: position.top,
      end: position.end,
      bottom: position.bottom,
      start: position.start,
      child: child,
    );
  }
}
