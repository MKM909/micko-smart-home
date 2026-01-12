import 'package:flutter/material.dart';

class PopBounce extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool play;

  const PopBounce({
    super.key,
    required this.child,
    required this.play,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
  });

  @override
  State<PopBounce> createState() => _PopBounceState();
}

class _PopBounceState extends State<PopBounce>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  bool hasPlayed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PopBounce oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.play && !hasPlayed) {
      hasPlayed = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play) {
      return widget.child;
    }

    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}
