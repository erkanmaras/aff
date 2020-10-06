import 'package:flutter/material.dart';
import 'package:aff/ui.dart';

class FieldButton extends StatelessWidget {
  const FieldButton({
    Key key,
    @required this.iconData,
    this.onTab,
    this.enable = true,
    this.padding,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.iconSize,
  }) : super(key: key);

  factory FieldButton.arrowDown({bool enable}) {
    return FieldButton(
      enable: enable,
      iconData: Icons.arrow_drop_down,
      iconSize: 24,
    );
  }

  factory FieldButton.calender({bool enable}) {
    return FieldButton(
      enable: enable,
      iconData: Icons.calendar_today,
      iconSize: 12,
      padding: EdgeInsets.only(left: 0, right: 21),
    );
  }

  factory FieldButton.clock({bool enable}) {
    return FieldButton(
      enable: enable,
      iconData: Icons.schedule,
      iconSize: 14,
      padding: EdgeInsets.only(left: 0, right: 20),
    );
  }

  factory FieldButton.clear({VoidCallback onTab, bool enable}) {
    return FieldButton(
      onTab: onTab,
      enable: enable,
      iconData: Icons.close,
      iconSize: 18,
      padding: EdgeInsets.only(left: 0, right: 18),
    );
  }

  final VoidCallback onTab;
  final IconData iconData;
  final Color iconEnabledColor;
  final Color iconDisabledColor;
  final double iconSize;
  final bool enable;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (onTab == null) {
      return buildIcon(context);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enable ? onTab : null,
      child: buildIcon(context),
    );
  }

  Widget buildIcon(BuildContext context) {
    var appTheme = context.getTheme();
    var color = enable
        ? (iconEnabledColor ?? appTheme.colors.font)
        : (iconDisabledColor ?? appTheme.colors.fontPale);
    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 15),
      child: Icon(iconData, color: color, size: iconSize),
    );
  }
}
