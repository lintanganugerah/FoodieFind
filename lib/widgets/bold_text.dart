import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final double size;
  final Color color;
  final String text;
  final TextAlign? textAlignment;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? textMaxline;

  final List<Shadow>? textStyleShadow;

  const BoldText({
    super.key,
    required this.text,
    this.size = 12,
    this.color = Colors.black,
    this.textAlignment,
    this.fontFamily,
    this.textOverflow,
    this.textMaxline,
    this.textStyleShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        shadows: textStyleShadow,
      ),
      textAlign: textAlignment,
      overflow: textOverflow,
      maxLines: textMaxline,
    );
  }
}
