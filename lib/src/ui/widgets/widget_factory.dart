import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';

class WidgetFactory {
  static Widget dotProgressIndicator({Color color, double size = 20, double boxSize}) {
    assert(boxSize == null || size <= boxSize);

    Widget indicator = ThreeDotWaitIndicator(color: color, size: size);

    if (boxSize != null) {
      return SizedBox(
        height: boxSize,
        width: boxSize,
        child: indicator,
      );
    }
    return indicator;
  }

  static Widget circularProgressIndicator({Color color, double size, double boxSize, double strokeWidth}) {
    assert(boxSize == null || size <= boxSize);

    var indicatorColor = color == null ? null : AlwaysStoppedAnimation<Color>(color);
    Widget indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth ?? 3,
      valueColor: indicatorColor,
    );

    if (size != null) {
      indicator = SizedBox(
        height: size,
        width: size,
        child: indicator,
      );
    }

    if (boxSize != null) {
      return SizedBox(
        height: boxSize,
        width: boxSize,
        child: indicator,
      );
    }

    return indicator;
  }

  static Widget circularIndicator(
      {@required AppTheme appTheme,
      double size,
      double progressBarWidth = 1,
      double maxValue = 0,
      double value = 0,
      TextStyle mainLabelStyle,
      List<Color> colors,
      bool animate = true}) {
    return CircularIndicator(
      appearance: CircularIndicatorAppearance(
          progressBarWidth: progressBarWidth,
          customColors: CircularIndicatorColors(
            trackColor: appTheme.colors.fontPale.withOpacity(0.5),
            progressBarColors: colors ??
                [
                  appTheme.colors.primary.withOpacity(0.5),
                  appTheme.colors.success,
                ],
          ),
          infoProperties: CircularIndicatorInfoProperties(
              modifier: (progressValue) {
                final valueInt = progressValue.toInt();
                final maxInt = maxValue.toInt();
                return '$valueInt/$maxInt';
              },
              mainLabelStyle: mainLabelStyle),
          startAngle: 180,
          angleRange: 360,
          size: size,
          animationEnabled: animate),
      max: maxValue,
      min: 0,
      initialValue: math.min(math.max(0, value), maxValue),
    );
  }

  static Widget linearProgressIndicator(
      {@required AppTheme appTheme,
      @required double progressBarHeight,
      @required double value,
      double width,
      List<Color> colors,
      bool animationEnabled = true}) {
    return LinearIndicator(
      appearance: LinearIndicatorAppearance(
          width: width,
          progressBarHeight: progressBarHeight,
          customColors: LinearIndicatorColors(
            trackColor: appTheme.colors.fontPale.withOpacity(0.5),
            progressBarColors: colors ??
                [
                  appTheme.colors.primary.withOpacity(0.5),
                  appTheme.colors.success,
                ],
          ),
          animationEnabled: animationEnabled ?? false),
      initialValue: value,
    );
  }

  static Widget emptyWidget() {
    return SizedBox.shrink();
  }

  static Widget rowLabelValue(
      {@required AppTheme appTheme,
      @required MediaQueryData mediaQuery,
      @required String label,
      @required String value,
      TextStyle labelStyle,
      TextStyle valueStyle}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: mediaQuery.size.shortestSidePercent(80),
                minWidth: mediaQuery.size.shortestSidePercent(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(label,
                    overflow: TextOverflow.ellipsis, maxLines: 2, style: labelStyle ?? appTheme.textStyles.body),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(value,
                    overflow: TextOverflow.ellipsis, maxLines: 2, style: valueStyle ?? appTheme.textStyles.bodyBold)),
          )),
        ],
      ),
    );
  }

  static Widget extendedListTile({
    @required AppTheme appTheme,
    @required Map<String, AlignmentGeometry> rowValues,
    @required List<String> colValues,
    GestureTapCallback onTab,
    EdgeInsets margin = const EdgeInsets.all(0),
    bool suffixIconVisible = true,
  }) {
    var rowWidgets = <Widget>[];
    for (MapEntry<String, AlignmentGeometry> entry in rowValues.entries) {
      if (entry.value != null || entry.value != Alignment.center) {
        rowWidgets.add(Align(
          alignment: entry.value,
          child: Text(
            entry.key,
            overflow: TextOverflow.ellipsis,
          ),
        ));
      } else {
        rowWidgets.add(Text(
          entry.key,
          overflow: TextOverflow.ellipsis,
        ));
      }
    }

    var colWidgets = <Widget>[];
    if (colValues != null) {
      for (var value in colValues) {
        if (!value.isNullOrWhiteSpace()) {
          colWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: appTheme.data.textTheme.caption.copyWith(color: appTheme.colors.fontPale),
              ),
            ),
          );
        }
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: margin,
      elevation: 0,
      child: InkWell(
        onTap: onTab,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ExpandedRow(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[...rowWidgets],
                          ),
                          if (colValues != null) ...colWidgets,
                        ],
                      ),
                    ),
                    if (suffixIconVisible) Icon(AppIcons.chevronRight, color: appTheme.colors.fontPale.withOpacity(0.5))
                  ],
                ))),
      ),
    );
  }

  static Widget extendedCheckboxListTile(
      {@required AppTheme appTheme,
      @required Map<String, AlignmentGeometry> rowValues,
      @required List<String> colValues,
      @required void Function(bool) onChanged,
      @required bool checkValue,
      EdgeInsets margin = const EdgeInsets.all(0),
      void Function() onTab,
      bool enable = true}) {
    final Widget control = Checkbox(
      value: checkValue,
      onChanged: enable ? onChanged : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    var rowWidgets = <Widget>[];
    for (MapEntry<String, AlignmentGeometry> entry in rowValues.entries) {
      if (entry.value != null || entry.value != Alignment.center) {
        rowWidgets.add(Align(
          alignment: entry.value,
          child: Text(
            entry.key,
            overflow: TextOverflow.ellipsis,
          ),
        ));
      } else {
        rowWidgets.add(Text(
          entry.key,
          overflow: TextOverflow.ellipsis,
        ));
      }
    }

    var colWidgets = <Widget>[];
    if (colValues != null) {
      for (var value in colValues) {
        colWidgets.add(
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: appTheme.data.textTheme.caption.copyWith(color: appTheme.colors.fontPale),
            ),
          ),
        );
      }
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: margin,
      elevation: 0,
      child: InkWell(
        onTap: () {
          if (onTab != null) {
            onTab();
          }
          if (onChanged != null) {
            onChanged(!checkValue);
          }
        },
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    control,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ExpandedRow(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[...rowWidgets],
                          ),
                          if (colValues != null) ...colWidgets,
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
