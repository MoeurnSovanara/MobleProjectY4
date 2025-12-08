import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class carouselWidget extends StatelessWidget {
  const carouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        pauseAutoPlayOnTouch: true,
      ),
      items: [1].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              'assets/img/sample/event.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            );
          },
        );
      }).toList(),
    );
  }
}
