import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';

/// Card(
///       margin: EdgeInsets.all(1),
///       child: Column(
///         children: <Widget>[CardTitle(title: title), ...columnItems],
///       ),
/// );
class CardTitle extends StatelessWidget {
  CardTitle({this.title, this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    var color = this.color ?? appTheme.colors.primary;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: appTheme.textStyles.subtitleBold.copyWith(color: color),
          ),
        ),
        IndentDivider(
          color: color.lighten(0.3),
        ),
      ],
    );
  }
}

class ContentTitle extends StatelessWidget {
  ContentTitle(
      {@required this.title,
      this.padding = const EdgeInsets.all(5),
      this.color,
      this.decoration})
      : assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".');

  final String title;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final Color color;
  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return Container(
      decoration: decoration,
      color: decoration == null ? color ?? appTheme.colors.canvas : null,
      alignment: Alignment.centerLeft,
      padding: padding,
      child: Row(
        children: <Widget>[
          Icon(AppIcons.chevronRight, size: 18, color: appTheme.colors.primary),
          Text(title,
              style: appTheme.textStyles.subtitleBold
                  .copyWith(color: appTheme.colors.primary)),
        ],
      ),
    );
  }
}
