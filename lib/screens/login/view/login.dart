// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:park_in_here/screens/login/controller/login_controller.dart';
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
  bool codeEmpty = false;
  bool mobEmpty = false;

  @override
  void initState() {
    getT();
    super.initState();
  }

  getT() async {
    GetStorage store = GetStorage();
    var token = await store.read('token');
    log('----$token');
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    TextStyle tstyle = GoogleFonts.inter(
      color: const Color(0xFF192242),
    );
    return SafeArea(
        child: GetBuilder<LoginController>(
            init: LoginController(),
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
                            height: h * 0.2,
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
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                        textStr('Number', 14, FontWeight.w600, 'Inter',
                            TextDecoration.none, const Color(0xFF192242)),
                        gap(15),
                        numberBox(),
                        if (mobEmpty == true)
                          textStr(
                              'Mobile should not be empty',
                              10,
                              FontWeight.w400,
                              'Inter',
                              TextDecoration.none,
                              Colors.red),
                        gap(15),
                        textStr('Passcode', 14, FontWeight.w600, 'Inter',
                            TextDecoration.none, const Color(0xFF192242)),
                        gap(10),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: passcodeField(),
                        ),
                        if (mobEmpty == true)
                          textStr(
                              'Passcode should not be empty',
                              10,
                              FontWeight.w400,
                              'Inter',
                              TextDecoration.none,
                              Colors.red),
                        gap(20),
                        loginBtn(controller),
                        gap(15),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                    () => const RegisterScreen(isReset: true));
                              },
                              child: textStr(
                                  'Forgot Passcode',
                                  14,
                                  FontWeight.w400,
                                  'Lato',
                                  TextDecoration.underline,
                                  const Color(0xFF192242)),
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
                ))));
  }

  Widget textStr(String title, double size, FontWeight weight, String family,
      TextDecoration decrtn, Color color) {
    TextStyle tstyle = const TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      height: 1.40,
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
          color: const Color.fromARGB(255, 183, 203, 239).withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: TextField(
          controller: mobCtrlr,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF677191),
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              hintText: 'E.g. 91 - 790 - 230 - 3563'),
        )

        // ),
        );
  }

  Widget passcodeField() {
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

  Widget loginBtn(LoginController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: InkWell(
        onTap: () {
          if (mobCtrlr.text == "") {
            setState(() {
              mobEmpty = true;
            });
          } else {
            setState(() {
              mobEmpty = false;
            });
          }
          if (pinCtrlr.text == "") {
            setState(() {
              codeEmpty = true;
            });
          } else {
            setState(() {
              codeEmpty = false;
            });
          }
          if (mobCtrlr.text != "" && pinCtrlr.text != "") {
            controller.login(mobCtrlr.text, pinCtrlr.text);
          }
        },
        child: Container(
          // width: 355,
          height: 55,
          decoration: ShapeDecoration(
            color: const Color.fromARGB(255, 102, 137, 242),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.50),
            ),
          ),
          child: Center(
            child: controller.isLoading == true
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : textStr('Login  →', 16, FontWeight.w700, 'Lato',
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
          child: textStr('Create Account', 16, FontWeight.w500, 'Lato',
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
        textStr('Terms and conditions ', 12, FontWeight.w400, 'Inter',
            TextDecoration.none, const Color(0xFF192242)),
        textStr(' | ', 12, FontWeight.w400, 'Inter', TextDecoration.none,
            const Color(0xFF192242)),
        textStr(' Privacy and policy', 12, FontWeight.w400, 'Inter',
            TextDecoration.none, const Color(0xFF192242)),
      ],
    );
  }

  Widget gap(double h) {
    return SizedBox(height: h);
  }
}
