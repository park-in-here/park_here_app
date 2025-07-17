import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_in_here/screens/login/view/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  List<String> images = [
    'assets/images/bg1.png',
    'assets/images/bg2.png',
    'assets/images/bg3.png'
  ];
  List<String> titles = [
    'Welcome to Parkinhere',
    'Find Parking',
    'Got Free Space Near Home?'
  ];
  List<String> descrptns = [
    'The easiest way to find and reserve parking spots in your city',
    'Discover available parking spaces near your destination in real-time.',
    'Even your driveway, garage, or empty plot can earn you money daily. Rent it out with Caniparkhere in just a few taps.'
  ];
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Total time: 2 seconds
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (currentIndex == 0) {
      _controller.forward(
          from: 0); // Restart animation when returning to first screen
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        images[currentIndex],
                        fit: BoxFit.fill,
                        height: h * 0.58,
                        width: w,
                      ),
                      if (currentIndex == 0)
                        Positioned(
                          top: h * 0.28,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              FadeTransition(
                                opacity: _logoAnimation,
                                child: Image.asset(
                                  'assets/images/logo2.png',
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeTransition(
                                opacity: _textAnimation,
                                child: textStr(
                                  'Park Smart.Park Space',
                                  26,
                                  FontWeight.w900,
                                  Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textStr(
                          titles[currentIndex],
                          24,
                          FontWeight.w700,
                          const Color(0xFF192342),
                        ),
                        gap(15),
                        textStr(
                          descrptns[currentIndex],
                          15,
                          FontWeight.w400,
                          const Color(0xFF707070),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Buttons Fixed
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentIndex < 2) {
                      setState(() {
                        currentIndex += 1;
                      });
                    } else {
                      Get.to(() => const LoginScreen());
                      // Navigate or do something else
                    }
                  },
                  child: nextBtn(),
                ),
                gap(10),
                if (currentIndex == 0)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 2; // Skip to last screen
                      });
                    },
                    child: textStr(
                      'Skip',
                      14,
                      FontWeight.w600,
                      const Color(0xFF707070),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textStr(String title, double size, FontWeight weight, Color color) {
    TextStyle tstyle = const TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      height: 1.40,
    );
    return Text(title,
        style: tstyle.copyWith(
            fontSize: size, fontWeight: weight, color: color, height: 1.60));
  }

  Widget nextBtn() {
    return Container(
      width: 355,
      height: 48,
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 102, 137, 242),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27.50),
        ),
      ),
      child: Center(
        child: textStr(
          'Next',
          16,
          FontWeight.w500,
          Colors.white,
        ),
      ),
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }
}
