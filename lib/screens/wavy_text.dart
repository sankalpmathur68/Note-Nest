import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavyTextAnimation extends StatefulWidget {
  @override
  _WavyTextAnimationState createState() => _WavyTextAnimationState();
}

class _WavyTextAnimationState extends State<WavyTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            painter: WavyTextPainter(animation: _controller),
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class WavyTextPainter extends CustomPainter {
  final Animation<double> animation;

  WavyTextPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Wavy Text',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final waveOffset = 20.0 * math.sin(animation.value * math.pi * 2);

    canvas.translate(0, waveOffset);

    textPainter.paint(canvas, Offset(10, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
