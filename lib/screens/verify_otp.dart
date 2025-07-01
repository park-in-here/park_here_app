import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/passcode.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  final bool isReset;
  const VerifyOtpScreen({super.key, required this.isReset});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
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
                'assets/images/logo.png',
                height: h * 0.24,
                width: w * 0.2,
              ),
            ),
            gap(30),
            if (widget.isReset == false)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Securely Register to\n',
                        style: tstyle.copyWith(
                            height: 1.4,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: 'ParkInHere ',
                        style: tstyle.copyWith(
                            height: 2,
                            fontSize: 30,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            if (widget.isReset == true)
              textStr('Reset your Passcode', 18, FontWeight.bold, 'Inter',
                  TextDecoration.none, const Color(0xFF192242)),
            gap(15),
            textStr('Enter Your OTP', 14, FontWeight.w600, 'Inter',
                TextDecoration.none, const Color(0xFF192242)),
            gap(10),
            otpField(),
            gap(40),
            otpBtn(),
          ],
        ),
      ),
    )));
  }

  Widget textStr(String title, double size, FontWeight weight, String family,
      TextDecoration decrtn, Color color) {
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
    return Text(title,
        style: tstyle.copyWith(
            fontSize: size,
            fontWeight: weight,
            fontFamily: family,
            color: color,
            decoration: decrtn));
  }

  Widget otpField() {
    const focusedBorderColor = Color.fromARGB(255, 219, 226, 249);
    const fillColor = Color.fromARGB(255, 234, 236, 243);

    final defaultPinTheme = PinTheme(
      width: 70,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(19),
      ),
    );

    return Pinput(
      length: 4,
      controller: otpCtrl,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
    );
  }

  Widget otpBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => const PassCodeScreen());
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
            child: textStr('verify OTP', 16, FontWeight.w700, 'Lato',
                TextDecoration.none, Colors.white),
          ),
        ),
      ),
    );
  }

  Widget createBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Container(
        // width: 355,
        height: 55,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.50),
              side: const BorderSide(color: Colors.black)),
        ),
        child: Center(
          child: textStr('Create Account', 16, FontWeight.w700, 'Lato',
              TextDecoration.none, Colors.black),
        ),
      ),
    );
  }

  Widget termsPrivacy() {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textStr('Terms and conditions', 12, FontWeight.w400, 'Inter',
            TextDecoration.none, const Color(0xFF192242)),
        textStr('|', 12, FontWeight.w400, 'Inter', TextDecoration.none,
            const Color(0xFF192242)),
        textStr('Privacy and policy', 12, FontWeight.w400, 'Inter',
            TextDecoration.none, const Color(0xFF192242)),
      ],
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }
}
