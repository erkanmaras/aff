import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  ContentContainer({this.child, this.margin});

  final Widget child;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: child,
    );
  }
}
