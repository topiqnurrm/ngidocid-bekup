import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FadedImageCarousel extends StatefulWidget {
  const FadedImageCarousel({super.key});

  @override
  State<FadedImageCarousel> createState() => _FadedImageCarouselState();
}

class _FadedImageCarouselState extends State<FadedImageCarousel> {
  List<String> imagePaths = List.generate(
    5,
    (index) => 'assets/images/banners/home_banner_${index + 1}.svg',
  );

  int _currentIndex = 0;
  double _opacity = 1.0;
  late Timer _timer;

  void _startFadeTimer() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _currentIndex = (_currentIndex + 1) % imagePaths.length;
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startFadeTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: SvgPicture.asset(imagePaths[_currentIndex], fit: BoxFit.cover),
        ),
      ),
    );
  }
}
