import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login.dart';

class CarouselWithIndicatorPage extends StatefulWidget {
  @override
  _CarouselWithIndicatorPageState createState() =>
      _CarouselWithIndicatorPageState();
}

class _CarouselWithIndicatorPageState extends State<CarouselWithIndicatorPage> {
  int _currentIndex = 0;
  //final CarouselController _carouselController = CarouselController();

  // List of images and corresponding texts
  final List<String> _carouselImages = <String>[
    'assets/images/image1.jpg',
    'assets/images/background.jpg',
    'assets/images/image3.jpg',
  ];

  final List<String> _carouselTexts = [
    'This is the description for Image 1.',
    'This is the description for Image 2.',
    'This is the description for Image 3.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Title at the top of the screen
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'DIY Hacks',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Carousel Slider
          Center(
            child: CarouselSlider.builder(
              itemCount: _carouselImages.length,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.6,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        _carouselImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Text(
                        _carouselTexts[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Smooth Page Indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: _carouselImages.length,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),

          // Centered Login Button at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to LoginPage when button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.blue, // Customize color
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
