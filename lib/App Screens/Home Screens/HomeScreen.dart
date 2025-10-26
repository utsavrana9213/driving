import 'package:avtoskola_varketilshi/App%20Screens/Ticket%20Screens/TikcetsScreen.dart';
import 'package:avtoskola_varketilshi/Controllers/Subject%20Controllers/subject_controller.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:avtoskola_varketilshi/l10n/app_localizations.dart';

import '../../App Widegts/CommonButton.dart';
import '../../Controllers/category_controller.dart';
import '../Exams Screens/exam_screen.dart';
import '../Exams Screens/enhanced_exam_screen.dart';
import '../Subjects screens/subject_list_screen.dart';
import '../SubCategory Screens/subcategory_list_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final carItems = [
    {'image': 'assets/images/car.png', 'label': 'B, B1'},
    {'image': 'assets/images/truck.png', 'label': 'C'},
    {'image': 'assets/images/bus.png', 'label': 'D'},
    {'image': 'assets/images/tractor.png', 'label': 'T, S'},
  ];

  void _openDialer() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.error, 
        AppLocalizations.of(Get.context!)!.couldNotOpenDialer
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryCtrl = Get.put(CategoryController());
    final subjectCtrl = Get.put(SubjectController());
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      body: Obx(() {
        final idx = categoryCtrl.currentIndex.value;
        final car = carItems[idx];

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Language switching button at top
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
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
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.homeTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.homeSubtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _openDialer,
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    '+995 574 74 75 81',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(186, 20, 29, 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 70),

                /// Car Swiper
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        final newIndex =
                            (idx - 1 + carItems.length) % carItems.length;
                        categoryCtrl.setIndex(newIndex);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xffFA1201),
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(car['image']!, height: 150),
                        const SizedBox(height: 8),
                        Text(
                          car['label']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        final newIndex = (idx + 1) % carItems.length;
                        categoryCtrl.setIndex(newIndex);
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xffFA1201),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),

                /// Buttons
                CommonRedButton(
                  label: AppLocalizations.of(context)!.bySubject,
                  onPressed: () {
                    final categoryCtrl = Get.find<CategoryController>();
                    final selectedCategory = categoryCtrl.currentLabel;
                    
                    // Navigate to sub-category list for practice mode
                    Get.to(
                      () => const SubCategoryListScreen(),
                      arguments: selectedCategory,
                    );
                  },
                ),
                const SizedBox(height: 16),
                CommonRedButton(
                  label: AppLocalizations.of(context)!.allTickets,
                  onPressed: () {
                    final categoryCtrl = Get.find<CategoryController>();
                    final selectedCategory = categoryCtrl.currentLabel;

                    // Register controller and pass argument only after Get.to
                    Get.to(() => TicketsScreen(), arguments: selectedCategory);
                  },
                ),
                const SizedBox(height: 16),
                CommonRedButton(
                  label: AppLocalizations.of(context)!.exam,
                  onPressed: () {
                    final categoryCtrl = Get.find<CategoryController>();
                    final selectedCategory = categoryCtrl.currentLabel;

                    // Use the enhanced exam screen with all new features
                    Get.to(() => const EnhancedExamScreen(), arguments: selectedCategory);
                  },
                ),
              ],
            ),
          ),
        );
      }),
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
