import 'dart:async';
import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avtoskola_varketilshi/l10n/app_localizations.dart';

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
    final languageController = Get.find<LanguageController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              /// Language switching button at top
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showLanguageDialog(context),
                    icon: const Icon(Icons.language, size: 18),
                    label: Text(
                      languageController.isEnglish ? 'EN' : 'KA',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(70, 35),
                    ),
                  ),
                ),
              ),
              
              /// Logo and text
              const Spacer(),
              Image.asset(
                'assets/images/logo.png', // Replace with your logo path
               
              ),
              
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 26),
                child: Text(
                  AppLocalizations.of(context)!.splashTitle,
                  style: const TextStyle(
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
  
  void _showLanguageDialog(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇺🇸'),
                title: Text(AppLocalizations.of(context)!.english),
                onTap: () {
                  languageController.changeLanguage('en');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Text('🇬🇪'),
                title: Text(AppLocalizations.of(context)!.georgian),
                onTap: () {
                  languageController.changeLanguage('ka');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
