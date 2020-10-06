import 'package:flutter/material.dart';

List<Widget> _wrapWithExpanded(List<Widget> children, Map<int, int> flexs) {
  var _expandeds = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    var child = children[i];

    if (child is Expanded) {
      _expandeds.add(child);
    } else {
      _expandeds.add(Expanded(
        flex: flexs == null ? 1 : flexs[i] ?? 1,
        child: child,
      ));
    }
  }

  return _expandeds;
}

class ExpandedColumn extends Column {
  ExpandedColumn(
      {Key key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      TextDirection textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down,
      TextBaseline textBaseline,
      List<Widget> children = const <Widget>[],
      Map<int, int> flexs})
      : super(
          children: _wrapWithExpanded(children, flexs),
          key: key,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
        );
}

class ExpandedRow extends Row {
  ExpandedRow(
      {Key key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      TextDirection textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down,
      TextBaseline textBaseline,
      List<Widget> children = const <Widget>[],
      Map<int, int> flexs})
      : super(
          children: _wrapWithExpanded(children, flexs),
          key: key,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
        );
}
