import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

import 'package:flutter/services.dart';

/// A reusable card component following the ForgeRoutine design system.
/// Features a dark surface, subtle border, and optional neon shadow.
class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final bool showShadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius = 12.0,
    this.showShadow = true,
    this.onTap,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardBody = ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.bgCard,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: widget.showShadow
              ? [
                  BoxShadow(
                    color: AppColors.accentGreen.withAlpha(15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          HapticFeedback.lightImpact();
          widget.onTap!();
        },
        onTapCancel: () => _controller.reverse(),
        behavior: HitTestBehavior.opaque,
        child: cardBody,
      );
    }

    return cardBody;
  }
}
