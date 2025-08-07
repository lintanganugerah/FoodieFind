import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final double size;
  final Color color;
  final String text;

  const BoldText({
    super.key,
    required this.text,
    this.size = 12,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold
    ));
  }
}
