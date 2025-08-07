import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry containerPadd;

  final Color? color;
  final AlignmentGeometry? containerAlignment;
  final Decoration? containerDecoration;
  final Decoration? containerForegroundDecoration;
  final BoxConstraints? containerConstraints;
  final EdgeInsetsGeometry? containerMargin;
  final Matrix4? containerTransform;
  final AlignmentGeometry? containerTransformAlignment;
  final Clip clipBehavior;

  final bool isShadow;
  final List<BoxShadow>? boxShadow;

  final Widget child;

  const CardContainer({
    super.key,
    this.width = 150,
    this.height = 200,
    this.color = Colors.white,
    this.containerPadd = const EdgeInsetsGeometry.all(16),
    this.containerAlignment,
    this.containerDecoration,
    this.containerForegroundDecoration,
    this.containerConstraints,
    this.containerMargin,
    this.containerTransform,
    this.containerTransformAlignment,
    this.clipBehavior = Clip.none,
    this.isShadow = false,
    this.boxShadow,
    required this.child,
  }) : assert(
  !(isShadow == true && containerDecoration != null),
  'Kamu tidak bisa memberikan params isShadow=true dan containerDecoration bersamaan. Ini akan menyebabkan konflik. Hapus salah satu nya.',
  );

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        containerDecoration ??
            BoxDecoration(
              color: color,
              boxShadow: isShadow
                  ? (boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ])
                  : null,
              borderRadius: BorderRadius.circular(12),
            );

    return Container(
      width: width,
      height: height,
      color: isShadow ? null : color,
      padding: containerPadd,
      decoration: effectiveDecoration,
      alignment: containerAlignment,
      foregroundDecoration: containerForegroundDecoration,
      constraints: containerConstraints,
      margin: containerMargin,
      transform: containerTransform,
      transformAlignment: containerTransformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
