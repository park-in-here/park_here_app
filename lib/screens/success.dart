import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/home.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gap(35),
                          Center(
                            child: Image.asset(
                              'assets/images/success.png',
                              height: h * 0.28,
                              width: w * 0.3,
                            ),
                          ),
                          gap(10),
                          Align(
                            alignment: Alignment.center,
                            child: textStr('ParkInHere', 40, FontWeight.w700,
                                'Inter', TextDecoration.none, Colors.black),
                          ),
                          gap(h * 0.08),
                          textStr(' Passcode Created!', 30, FontWeight.w400,
                              'Inter', TextDecoration.none, Colors.black),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: textStr(
                                '   The smart parking platform for urban drivers & space owners',
                                16,
                                FontWeight.w500,
                                'Lato',
                                TextDecoration.none,
                                Colors.grey),
                          ),
                          gap(30),
                          homeBtn()
                        ])))));
  }

  Widget homeBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => const HomeScreen());
        },
        child: Container(
          // width: 355,
          height: 55,
          decoration: ShapeDecoration(
            color: const Color(0xFF567DF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.50),
            ),
          ),
          child: Center(
            child: textStr('Take me to Home', 16, FontWeight.w700, 'Lato',
                TextDecoration.none, Colors.white),
          ),
        ),
      ),
    );
  }

  Widget textStr(String title, double size, FontWeight weight, String family,
      TextDecoration decrtn, Color color) {
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
    return Text(title,
        textAlign: TextAlign.justify,
        style: tstyle.copyWith(
            fontSize: size,
            fontWeight: weight,
            fontFamily: family,
            color: color,
            decoration: decrtn));
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }
}
