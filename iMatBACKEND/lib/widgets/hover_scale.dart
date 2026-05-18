import 'package:flutter/material.dart';

/// Scales [child] slightly on pointer hover. Optional [onTap].
class HoverScale extends StatefulWidget {
  final Widget child;
  final double hoverScale;
  final VoidCallback? onTap;

  const HoverScale({
    super.key,
    required this.child,
    this.hoverScale = 1.04,
    this.onTap,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _hovering ? widget.hoverScale : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
