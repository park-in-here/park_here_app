import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/screens/login/view/login.dart';
import 'package:park_in_here/screens/home/view/home.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/screens/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:park_in_here/screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init(); // Initialize storage
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final logged = box.read('logged');
    log('logged $logged, token $token');
    return ProviderScope(
      child: GetMaterialApp(debugShowCheckedModeBanner: false, home: 
          logged == true
              ? const HomeScreen()
              : token != null
                  ? const LoginScreen()
                  : const OnboardingScreen(),
         
          ),
    );
  }
}
