import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/home/view/home.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Text(
      'gggg',
      style: TextStyle(fontSize: 30, color: Colors.amberAccent),
    ),
    const Text(''),
    const Text(''),
    const Text('')
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: imageItem('assets/images/home.png', Colors.black),
            activeIcon: activeIcon('assets/images/home.png', 'Home'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: imageItem('assets/images/search.png', Colors.black),
            activeIcon: activeIcon('assets/images/search.png', ''),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: imageItem('assets/images/pie-chart.png', Colors.black),
            activeIcon: activeIcon('assets/images/pie-chart.png', ''),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: imageItem('assets/images/clock.png', Colors.black),
            activeIcon: activeIcon('assets/images/clock.png', ''),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: imageItem('assets/images/user.png', Colors.black),
            activeIcon: activeIcon('assets/images/user.png', ''),
            label: '',
          )
        ],
      ),
      body: Container(
        child: _screens[_currentIndex],
        // child: Image.asset('assets/images/map_bg.png'),
      ),
    );
  }

  Widget imageItem(String title, Color color) {
    return Image.asset(
      title,
      height: 20,
      width: 20,
      color: color,
    );
  }

  Widget textItem(String title, Color color, double size, FontWeight weight) {
    return Text(title,
        style: GoogleFonts.poppins(
            color: color, fontSize: size, fontWeight: weight));
  }

  Widget activeIcon(String img, String title) {
    var w = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(18),
      child: Container(
          height: 40,
          width: w * 0.25,
          color: const Color(0xff3572EF),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                imageItem(img, Colors.white),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: textItem(title, Colors.white, 14, FontWeight.w500),
                )
              ],
            ),
          )),
    );
  }
}
