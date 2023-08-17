import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scicalci/screens/wavy_text.dart';

class GlassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.width;
    double currentWidth = MediaQuery.of(context).size.height;
    return Container(
      // margin: EdgeInsets.all(20),
      // height: currentHeight,
      // width: currentWidth,
      // padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.4),
        //     spreadRadius: 4,
        //     blurRadius: 10,
        //     offset: Offset(0, 6),
        //   ),
        // ],
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.2),
            Colors.blue.withOpacity(0.1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Transform(
        transform: Matrix4.rotationX(0.0),
        // alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              // padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   color: Colors.white.withOpacity(0.5),
                //   width: 1,
                // ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WavyTextAnimation()
                  // Text(
                  //   'Loading...',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
