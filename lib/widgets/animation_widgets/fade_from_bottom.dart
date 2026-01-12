import 'package:flutter/material.dart';

class FadeFromBottom extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final bool play;

  const FadeFromBottom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 30,
    required this.play,
  });

  @override
  Widget build(BuildContext context) {
    if (!play) {
      // Hidden state (NO animation)
      return Opacity(
        opacity: 0,
        child: Transform.translate(
          offset: Offset(0, offset),
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
            offset: Offset(0, value),
            child: child,
          ),
        );
      },
    );
  }
}
