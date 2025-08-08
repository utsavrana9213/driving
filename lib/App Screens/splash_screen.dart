import 'dart:async';
import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Wait for 3 seconds then navigate to next screen
    Timer(const Duration(seconds: 3), () {
      Get.offAll(HomeScreen());
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              /// Logo and text
              Spacer(),
              Image.asset(
                'assets/images/logo.png', // Replace with your logo path
               
              ),
              
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 26),
                child: Text(
                  'AVTOSKOLA VARKETILSHI',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
