import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/verify_otp.dart';

class RegisterScreen extends StatefulWidget {
  final bool isReset;
  const RegisterScreen({super.key, required this.isReset});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameCtrl = TextEditingController();
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
            gap(30),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: h * 0.26,
                width: w * 0.2,
              ),
            ),
            gap(50),
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
            if (widget.isReset == false) gap(15),
            if (widget.isReset == false)
              textStr('Name', 14, FontWeight.w600, 'Inter', TextDecoration.none,
                  const Color(0xFF192242)),
            if (widget.isReset == false) gap(10),
            if (widget.isReset == false) textField(nameCtrl, 'E.g.Sudhin'),
            gap(20),
            textStr('Mobile Number', 14, FontWeight.w600, 'Inter',
                TextDecoration.none, const Color(0xFF192242)),
            gap(10),
            textField(mobCtrlr, '+6289876543210'),
            gap(40),
            otpBtn(widget.isReset),
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

  Widget textField(TextEditingController ctrlr, String hint) {
    return Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 11),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: TextField(
          controller: ctrlr,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              prefixIcon: ctrlr == mobCtrlr
                  ? Image.asset("assets/images/mob.png")
                  : null,
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF677191),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              hintText: hint),
        )

        // ),
        );
  }

  Widget otpBtn(bool reset) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => VerifyOtpScreen(
                isReset: reset,
              ));
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
            child: textStr('Send OTP→', 16, FontWeight.w700, 'Lato',
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
