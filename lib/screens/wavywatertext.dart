import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavyWaterTextAnimation extends StatefulWidget {
  @override
  _WavyWaterTextAnimationState createState() => _WavyWaterTextAnimationState();
}

class _WavyWaterTextAnimationState extends State<WavyWaterTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
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
      child: CustomPaint(
        painter: WavyWaterTextPainter(animation: _controller),
        child: Container(
          // width: 300,
          height: 100,
          child: Center(),
        ),
      ),
    );
  }
}

class WavyWaterTextPainter extends CustomPainter {
  final Animation<double> animation;

  WavyWaterTextPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final waveOffset = 10.0 * math.sin(animation.value * math.pi * 2);

    // Draw the water with animated wave patterns
    final waterGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue.shade100, Colors.blue.shade100],
    );

    final waterRect = Rect.fromPoints(
      Offset(0, size.height / 2),
      Offset(size.width, size.height),
    );

    final waterPaint = Paint()..shader = waterGradient.createShader(waterRect);

    // Create animated wave patterns
    final waveFrequency = 0.009; // Adjust this value for faster/slower waves
    final waveAmplitude = waveOffset * 2;

    for (double x = 0; x <= size.width; x += 0.1) {
      final y = size.height / 2 +
          waveAmplitude * math.sin(x * waveFrequency + waveOffset);
      canvas.drawLine(
        Offset(x, 800),
        Offset(x, y),
        waterPaint,
      );
    }

    // Draw the wavy text above the water
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Loading',
        style: TextStyle(
            fontSize: 24, color: Colors.black26, fontWeight: FontWeight.w400),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    canvas.translate(0, waveOffset);
    textPainter.paint(canvas, Offset(size.width / 3, size.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
