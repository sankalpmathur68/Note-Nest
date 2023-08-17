import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class WavyNatureTextAnimation extends StatefulWidget {
  @override
  _WavyNatureTextAnimationState createState() =>
      _WavyNatureTextAnimationState();
}

class _WavyNatureTextAnimationState extends State<WavyNatureTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
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
        painter: WavyTextPainter(animation: _controller),
        child: Container(
          // width: 300,
          height: 100,
          child: Center(),
        ),
      ),
    );
  }
}

class WavyTextPainter extends CustomPainter {
  final Animation<double> animation;

  WavyTextPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final text = 'Loading...';
    final words = text.split('');

    // final textStyle = TextStyle(
    //   fontSize: 24,
    //   fontWeight: FontWeight.bold,
    //   color: Colors.black,
    // );

    final spaceWidth = 10.0; // Adjust the space between words

    var xOffset = size.width / 3;
    for (var word in words) {
      final textPainter = TextPainter(
          text: TextSpan(
              text: word,
              style: GoogleFonts.lato(color: Colors.blue, fontSize: 20)),
          textDirection: TextDirection.ltr)
        ..layout(); // Layout the text painter

      final wordWidth = textPainter.width; // Get the width

      final animatedValue =
          animation.value + xOffset * 0.1; // Use animation.value
      final yOffset = 10.0 * math.sin(animatedValue * math.pi * 2);

      final path = Path()
        ..addRect(
            Rect.fromLTWH(xOffset, size.height / 2 + yOffset, wordWidth, 100));
      final rect =
          Rect.fromLTWH(xOffset, size.height / 2 + yOffset, wordWidth, 100);
      final gradient = LinearGradient(
        colors: [Colors.transparent, Colors.transparent],
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      textPainter.paint(canvas, Offset(xOffset, yOffset / 2));

      xOffset += wordWidth + spaceWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
