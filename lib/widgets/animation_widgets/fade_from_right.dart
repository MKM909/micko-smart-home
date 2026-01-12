import 'package:flutter/material.dart';

class FadeFromRight extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final bool play;

  const FadeFromRight({
    super.key,
    required this.child,
    required this.play,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (!play) {
      return Opacity(
        opacity: 0,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: offset, end: 0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: 1 - (value / offset),
          child: Transform.translate(
            offset: Offset(value, 0),
            child: child,
          ),
        );
      },
    );
  }
}
