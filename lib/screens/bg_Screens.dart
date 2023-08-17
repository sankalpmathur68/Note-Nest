import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Circle {
  double x;
  double y;
  double radius;
  Color color;
  double dx = 0.0;
  double dy = 0.0;

  Circle(this.x, this.y, this.radius, this.color) {
    dx = Random().nextDouble() * 2 - 1;
    dy = Random().nextDouble() * 2 - 1;
  }

  void move() {
    x += dx;
    y += dy;
  }

  void checkCollisionWithBounds(Size screenSize) {
    if (x - radius < 0 || x + radius > screenSize.width) {
      dx = -dx;
    }

    if (y - radius < 0 || y + radius > screenSize.height) {
      dy = -dy;
    }
  }

  void checkCollisionWithOtherCircle(Circle otherCircle) {
    if (this == otherCircle) return;

    double distance =
        sqrt(pow(x - otherCircle.x, 2) + pow(y - otherCircle.y, 2));
    if (distance < radius + otherCircle.radius) {
      // Elastic collision code remains the same as before
    }
  }
}

class CircleCollisionPage extends StatefulWidget {
  @override
  _CircleCollisionPageState createState() => _CircleCollisionPageState();
}

class _CircleCollisionPageState extends State<CircleCollisionPage> {
  List<Circle> circles = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 40; i++) {
      // double x = 300;
      // double y = 50;
      double x = Random().nextDouble() * 600 + 50; // Random x position
      double y = Random().nextDouble() * 700 + 50; // Random y position
      double radius = Random().nextDouble() * 20 + 10; // Random radius size
      Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      circles.add(Circle(x, y, radius, color));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => animateCircles());
  }

  void animateCircles() {
    setState(() {
      for (var circle in circles) {
        circle.move();
        circle.checkCollisionWithBounds(MediaQuery.of(context).size);

        for (var otherCircle in circles) {
          circle.checkCollisionWithOtherCircle(otherCircle);
        }
      }
    });

    Future.delayed(Duration(milliseconds: 1), () => animateCircles());
  }

  void addCirclesOnTap(Offset tapPosition) {
    setState(() {
      for (int i = 0; i < 10; i++) {
        double x = tapPosition.dx + Random().nextDouble() * 50 - 25;
        double y = tapPosition.dy + Random().nextDouble() * 50 - 25;
        double radius = Random().nextDouble() * 20 + 10;
        Color color =
            Colors.primaries[Random().nextInt(Colors.primaries.length)];
        circles.add(Circle(x, y, radius, color));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          addCirclesOnTap(details.localPosition);
        },
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: CirclePainter(circles),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  List<Circle> circles;

  CirclePainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      double depth = circle.radius / 4;
      final gradient = RadialGradient(
        colors: [
          Colors.white.withOpacity(1),
          circle.color,
          circle.color,
        ],
        stops: [0.0, 0.8 - depth, 1.8 + depth],
        center: Alignment(0.0, 0.0),
        radius: 1.0,
      );

      final rect = Rect.fromCircle(
          center: Offset(circle.x, circle.y), radius: circle.radius);
      final paint = Paint()
        ..strokeWidth = 10
        ..shader = gradient.createShader(rect)
        ..color = Colors.black.withOpacity(1)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.0);

      // canvas.drawLine(Offset(circle.y, -50), Offset(-10, circle.y * 2), paint);
      canvas.drawCircle(Offset(circle.x, circle.y), circle.radius, paint);
      String text = '...'; // Replace with your desired text

      TextSpan textSpan =
          TextSpan(text: text, style: GoogleFonts.lato(color: Colors.black));
      TextPainter textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);

      // Layout and paint the text
      // textPainter.layout();
      // textPainter.paint(
      //     canvas, Offset(circle.x - circle.radius, circle.y - circle.radius));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
