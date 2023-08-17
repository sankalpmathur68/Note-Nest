import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scicalci/screens/bg_Screens.dart';
import 'package:scicalci/screens/glass_bg.dart';
import 'package:scicalci/screens/wavyNatureText.dart';
import 'package:scicalci/screens/wavywatertext.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WavyNatureTextAnimation());
  }
}
