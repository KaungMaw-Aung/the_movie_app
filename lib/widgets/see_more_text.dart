import 'package:flutter/material.dart';

class SeeMoreText extends StatelessWidget {
  final String titleText;
  final Color textColor;

  SeeMoreText(this.titleText, {this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
