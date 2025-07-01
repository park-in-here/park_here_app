import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/register/view/register.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController pinCtrlr = TextEditingController();
  TextEditingController mobCtrlr = TextEditingController();
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
                height: h * 0.22,
                width: w * 0.2,
              ),
            ),
            gap(30),
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
            gap(15),
            textStr('Number', 14, FontWeight.w600, 'Inter', TextDecoration.none,
                const Color(0xFF192242)),
            gap(10),
            numberBox(),
            gap(10),
            textStr('Passcode', 14, FontWeight.w600, 'Inter',
                TextDecoration.none, const Color(0xFF192242)),
            gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: passcodeField(),
            ),
            gap(20),
            loginBtn(),
            gap(15),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onTap: () {
                    Get.to(() => const RegisterScreen(isReset: true));
                  },
                  child: textStr('Forgot Passcode', 15, FontWeight.w500, 'Lato',
                      TextDecoration.underline, const Color(0xFF192242)),
                ),
              ),
            ),
            gap(15),
            GestureDetector(
                onTap: () {
                  Get.to(() => const RegisterScreen(
                        isReset: false,
                      ));
                },
                child: createBtn()),
            gap(15),
            termsPrivacy()
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

  Widget numberBox() {
    return Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: TextField(
          controller: mobCtrlr,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF677191),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              hintText: 'E.g. 91 - 790 - 230 - 3563'),
        )

        // ),
        );
  }

  Widget passcodeField() {
    const focusedBorderColor = Color.fromARGB(255, 219, 226, 249);
    const fillColor = Color(0xFFF3F6FF);

    final defaultPinTheme = PinTheme(
      width: 85,
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
      controller: pinCtrlr,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          log('${mobCtrlr.text} ${pinCtrlr.text}');
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
            child: textStr('Login  →', 16, FontWeight.w700, 'Lato',
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
