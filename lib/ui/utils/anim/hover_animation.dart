
import 'package:flutter/material.dart';

class HoverAnimation extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? transformSize;

  const HoverAnimation({
    super.key,
    required this.child,
    this.duration,
    this.transformSize,
  });

  @override
  State<HoverAnimation> createState() => _HoverAnimationState();
}

class _HoverAnimationState extends State<HoverAnimation> with SingleTickerProviderStateMixin {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverTransform = Matrix4.identity()
      ..translate(0, -1, 1)
      ..scale(widget.transformSize ?? 1.1);
    final transform = isHovered ? hoverTransform : Matrix4.identity();
    return MouseRegion(
      onEnter: (pointerEvent) {
        onEntered(true);
      },
      onExit: (pointerEvent) {
        onEntered(false);
      },
      child: AnimatedContainer(
        transform: transform,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }

  onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
