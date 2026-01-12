import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HangingLightRope extends StatefulWidget {
  final Color bulbColor;
  final Color inactiveBulbColor;
  final Color ropeColor;
  final double bulbRadius;
  final double glowRadius;
  final double pullThreshold;
  final double sluggishness; // 0.1 = very heavy, 1 = instant
  final Duration returnDuration;
  final VoidCallback onPulled;
  final double initialRopeLength;
  final Color bulbBorderColor;
  final Color bulbBgColor;
  final bool isGlowEnabled;

  const HangingLightRope({
    super.key,
    required this.onPulled,
    this.bulbColor = Colors.amber,
    this.inactiveBulbColor = Colors.grey,
    this.ropeColor = Colors.amberAccent,
    this.bulbRadius = 16,
    this.glowRadius = 24,
    this.pullThreshold = 120,
    this.sluggishness = 0.2,
    this.returnDuration = const Duration(milliseconds: 800),
    this.initialRopeLength = 200,
    this.bulbBorderColor = Colors.black,
    this.bulbBgColor = Colors.transparent,
    this.isGlowEnabled = true,
  });

  @override
  State<HangingLightRope> createState() => _HangingLightRopeState();
}

class _HangingLightRopeState extends State<HangingLightRope>
    with SingleTickerProviderStateMixin {
  late Offset anchor;
  late Offset bulbOffset;
  late Offset targetOffset;

  late AnimationController _controller;
  late Animation<Offset> _returnAnim;

  bool triggered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.returnDuration,
    )..addListener(() {
      setState(() {
        bulbOffset = _returnAnim.value;
        targetOffset = bulbOffset;
      });
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery
        .of(context)
        .size;
    anchor = Offset(size.width - 35, 0);
    bulbOffset = Offset(
      anchor.dx,
      widget.initialRopeLength,
    );

    targetOffset = bulbOffset;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: CustomPaint(
            size: Size.infinite,
            painter: _RopePainter(
              anchor: anchor,
              bulb: bulbOffset,
              color: widget.ropeColor,
              isGlowEnabled: widget.isGlowEnabled,
            ),
          ),
        ),


        Positioned(
          left: bulbOffset.dx - widget.bulbRadius - 8,
          top: bulbOffset.dy - widget.bulbRadius,
          child: GestureDetector(
            onPanStart: _onDragStart,
            onPanUpdate: _onDragUpdate,
            onPanEnd: _onDragEnd,
            child: _LightBulb(
              radius: widget.bulbRadius,
              glowRadius: widget.glowRadius,
              active: (bulbOffset.dy - anchor.dy) > 20,
              color: widget.bulbColor,
              inactiveColor: widget.inactiveBulbColor,
              bulbBorderColor: widget.bulbBorderColor,
              bulbBgColor: widget.bulbBgColor,
              isGlowEnabled: widget.isGlowEnabled,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _onDragStart(DragStartDetails details) {
    if (_controller.isAnimating) {
      _controller.stop(); // 👈 critical
    }

    targetOffset = bulbOffset;
  }


  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      // sluggish weighted movement
      targetOffset += details.delta;
      bulbOffset = Offset.lerp(
        bulbOffset,
        targetOffset,
        widget.sluggishness,
      )!;
    });

    if (!triggered &&
        (bulbOffset.dy - anchor.dy) > widget.pullThreshold) {
      triggered = true;
      HapticFeedback.lightImpact();
      widget.onPulled();
    }
  }


  void _onDragEnd(_) {
    triggered = false;

    _returnAnim = Tween<Offset>(
      begin: bulbOffset,
      end: Offset(anchor.dx, widget.initialRopeLength),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller
      ..reset()
      ..forward();
  }



}


class _RopePainter extends CustomPainter {
  final Offset anchor;
  final Offset bulb;
  final Color color;
  final bool isGlowEnabled;

  _RopePainter({
    required this.anchor,
    required this.bulb,
    required this.color,
    required this.isGlowEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..quadraticBezierTo(
        anchor.dx,
        (anchor.dy + bulb.dy) / 2,
        bulb.dx,
        bulb.dy,
      );

    if(isGlowEnabled) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawPath(path, glowPaint);
    }

    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class _LightBulb extends StatelessWidget {
  final double radius;
  final double glowRadius;
  final bool active;
  final Color color;
  final Color inactiveColor;
  final Color bulbBorderColor;
  final Color bulbBgColor;
  final bool isGlowEnabled;

  const _LightBulb({
    required this.radius,
    required this.glowRadius,
    required this.active,
    required this.color,
    required this.inactiveColor,
    required this.bulbBorderColor,
    required this.bulbBgColor,
    required this.isGlowEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final bulbColor = active ? color : inactiveColor;

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bulbBgColor,
        border: Border.all(
          color: bulbBorderColor,
          width: 4,
        ),
        boxShadow: isGlowEnabled && active
            ? [
          BoxShadow(
            color: bulbColor.withOpacity(0.3),
            blurRadius: glowRadius,
            spreadRadius: 4,
          ),
        ]
            : [],
      ),
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          color: bulbColor,
          shape: BoxShape.circle
        ),
      ),
    );
  }
}
