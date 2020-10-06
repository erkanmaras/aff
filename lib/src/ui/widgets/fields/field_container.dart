import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';

class FieldContainer extends StatelessWidget {
  FieldContainer({@required this.child, this.labelText, this.padding});

  final String labelText;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (labelText.isNullOrWhiteSpace()) {
      return Padding(
        padding: padding ?? const EdgeInsets.all(5),
        child: child,
      );
    }
    return Padding(
      padding: padding ?? const EdgeInsets.all(5),
      child: Column(children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
              child: Text(
                labelText,
                textAlign: TextAlign.left,
              ),
            )),
        child
      ]),
    );
  }
}
