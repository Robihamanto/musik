import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {

  final EdgeInsets? margin;

  const DividerWidget({Key? key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).dividerColor,
      margin: margin,
    );
  }
}
