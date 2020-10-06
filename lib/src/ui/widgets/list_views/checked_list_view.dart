import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aff/ui.dart';

class CheckedListView<T> extends StatefulWidget {
  CheckedListView({
    @required this.itemBuilder,
    @required this.list,
    this.itemMargin,
    this.itemPadding,
    this.itemDecoration,
    this.onCheckedChange,
    this.onTab,
    this.onTabTargetChanged,
  })  : assert(itemBuilder != null),
        assert(list != null);

  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(bool) onTabTargetChanged;
  final void Function(T) onTab;
  final void Function(T) onCheckedChange;
  final Map<T, bool> list;
  final EdgeInsets itemMargin;
  final EdgeInsets itemPadding;
  final BoxDecoration itemDecoration;

  @override
  State<StatefulWidget> createState() {
    return CheckedListViewState<T>();
  }
}

class CheckedListViewState<T> extends State<CheckedListView<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _scaleAnimation;
  AppTheme _appTheme;

  EdgeInsets get itemMargin => widget.itemMargin ?? const EdgeInsets.all(1);
  EdgeInsets get itemPadding =>
      widget.itemPadding ??
      const EdgeInsets.symmetric(vertical: 10, horizontal: 5);
  BoxDecoration get itemDecoration => widget.itemDecoration;

  void _toggleChecked(T item) {
    setState(() {
      widget.list[item] = !widget.list[item];
    });
  }

  void _checkedChange(T item) {
    if (widget.onCheckedChange != null) {
      widget.onCheckedChange(item);
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    var curve = CurveTween(curve: Curves.ease).animate(_animationController);
    var slideEnd = (2 * kRadialReactionRadius - itemPadding.left) /
        (WidgetsBinding.instance.window.physicalSize /
                WidgetsBinding.instance.window.devicePixelRatio)
            .shortestSide;
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(slideEnd, 0))
            .animate(curve);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(curve);
    super.initState();
  }

  @override
  void didUpdateWidget(CheckedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.list.values.any((value) => value) &&
        oldWidget.list.values.any((value) => value)) {
      _resetChecked();
    }
  }

  @override
  void didChangeDependencies() {
    _appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keysList = widget.list.keys.toList();
    return WillPopScope(
      onWillPop: _willPopHandler,
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          var currentItem = keysList[index];
          return Container(
            margin: itemMargin,
            decoration: itemDecoration,
            child: Material(
              elevation: 0,
              color: _appTheme.colors.canvasLight,
              child: InkWell(
                  // borderRadius: itemDecoration != null ? itemDecoration.borderRadius : BorderRadius.zero,
                  onLongPress: () {
                    setState(() {
                      _animationController.forward();
                      _toggleChecked(currentItem);
                      _onTabTargetChanged(true);
                      _checkedChange(currentItem);
                    });
                  },
                  onTap: () {
                    if (_animationController.isCompleted) {
                      _toggleChecked(currentItem);
                      _checkedChange(currentItem);
                    } else {
                      _onTab(currentItem);
                    }
                  },
                  child: Stack(children: <Widget>[
                    Padding(
                        padding: itemPadding,
                        child: SlideTransition(
                            position: _slideAnimation,
                            child: widget.itemBuilder(context, currentItem))),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Checkbox(
                            //minimize boxsize
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              _toggleChecked(currentItem);
                            },
                            value: _isChecked(currentItem),
                          )),
                    )),
                  ])),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _willPopHandler() async {
    return _resetChecked();
  }

  bool _resetChecked() {
    if (!_animationController.isDismissed) {
      _uncheckAll();
      _animationController.reverse();
      _onTabTargetChanged(false);
      return false;
    }
    return true;
  }

  bool _isChecked(T item) {
    return widget.list[item];
  }

  void _uncheckAll() {
    setState(() {
      for (var key in widget.list.keys) {
        widget.list[key] = false;
      }
    });
  }

  void _onTabTargetChanged(bool checkMode) {
    if (widget.onTabTargetChanged != null) {
      widget.onTabTargetChanged(checkMode);
    }
  }

  void _onTab(T item) {
    if (widget.onTab != null) {
      widget.onTab(item);
    }
  }
}
