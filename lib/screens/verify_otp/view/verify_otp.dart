// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:park_in_here/screens/passcode.dart';
import 'package:park_in_here/screens/verify_otp/controller/verify_otp_controller.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  final bool isReset;
  final String name;
  final String phone;
  const VerifyOtpScreen(
      {super.key,
      required this.isReset,
      required this.phone,
      required this.name});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpCtrl = TextEditingController();
  bool otpEmpty = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
    return SafeArea(
        child: GetBuilder<VerifyOtpController>(
            init: VerifyOtpController(),
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
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        if (widget.isReset == true)
                          textStr(
                              'Reset your Passcode',
                              18,
                              FontWeight.bold,
                              'Inter',
                              TextDecoration.none,
                              const Color(0xFF192242)),
                        gap(15),
                        textStr('Enter Your OTP', 14, FontWeight.w600, 'Inter',
                            TextDecoration.none, const Color(0xFF192242)),
                        gap(10),
                        otpField(),
                        if (otpEmpty == true)
                          textStr(
                              'OTP should not be empty',
                              10,
                              FontWeight.w400,
                              'Inter',
                              TextDecoration.none,
                              Colors.red),
                        gap(40),
                        otpBtn(controller, widget.name, widget.phone),
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

  Widget otpField() {
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

  Widget otpBtn(VerifyOtpController controller, String name, String phone) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          if (otpCtrl.text == "") {
            setState(() {
              otpEmpty = true;
            });
          } else {
            setState(() {
              otpEmpty = false;
            });
          }
          if (otpCtrl.text != "" && otpCtrl.text.length == 4) {
            controller.verifyOtp(name, phone, otpCtrl.text);
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
                : textStr('verify OTP', 16, FontWeight.w700, 'Lato',
                    TextDecoration.none, Colors.white),
          ),
        ),
      ),
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }
}
