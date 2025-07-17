// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/passcode/controller/passcode_controller.dart';
import 'package:pinput/pinput.dart';

class PassCodeScreen extends StatefulWidget {
  const PassCodeScreen({super.key});

  @override
  State<PassCodeScreen> createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  TextEditingController passCodeCtrl = TextEditingController();
  TextEditingController passCodeCtrl2 = TextEditingController();
  bool passEmpty = false;
  bool cnfPassEmpty = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
    return SafeArea(
        child: GetBuilder<PasscodeController>(
            init: PasscodeController(),
            builder: (controller) => Scaffold(
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
                        textStr('Passcode', 14, FontWeight.w500, 'Inter',
                            TextDecoration.none, const Color(0xFF192242)),
                        gap(10),
                        otpField(passCodeCtrl),
                        if (passEmpty == true)
                          textStr(
                              'Passcode should not be empty',
                              10,
                              FontWeight.w400,
                              'Inter',
                              TextDecoration.none,
                              Colors.red),
                        gap(15),
                        textStr(
                            'Confirm Passcode',
                            14,
                            FontWeight.w500,
                            'Inter',
                            TextDecoration.none,
                            const Color(0xFF192242)),
                        gap(10),
                        otpField(passCodeCtrl2),
                        if (cnfPassEmpty == true)
                          textStr(
                              'Confirm passcode should not be empty',
                              10,
                              FontWeight.w400,
                              'Inter',
                              TextDecoration.none,
                              Colors.red),
                        gap(40),
                        setBtn(controller),
                      ],
                    ),
                  ),
                ))));
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

  Widget otpField(TextEditingController ctrl) {
    const focusedBorderColor = Color.fromARGB(255, 219, 226, 249);
    const fillColor = Color.fromARGB(255, 183, 203, 239);

    final defaultPinTheme = PinTheme(
      width: 80,
      height: 50,
      margin: const EdgeInsets.all(4),
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return Pinput(
      length: 4,
      controller: ctrl,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
    );
  }

  Widget setBtn(
    PasscodeController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          if (passCodeCtrl.text == "") {
            setState(() {
              passEmpty = true;
            });
          } else {
            setState(() {
              passEmpty = false;
            });
          }
          if (passCodeCtrl2.text == "") {
            setState(() {
              cnfPassEmpty = true;
            });
          } else {
            setState(() {
              cnfPassEmpty = false;
            });
          }
          if (passCodeCtrl.text != "" && passCodeCtrl2.text != "") {
            controller.setPasscode(passCodeCtrl.text, passCodeCtrl2.text);
          }
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
            child: controller.isLoading == true
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : textStr('Setup Passcode', 16, FontWeight.w700, 'Lato',
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
