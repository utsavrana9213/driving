import 'package:avtoskola_varketilshi/App%20Screens/Ticket%20Screens/TikcetsScreen.dart';
import 'package:avtoskola_varketilshi/Controllers/Subject%20Controllers/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../App Widegts/CommonButton.dart';
import '../../Controllers/category_controller.dart';
import '../Exams Screens/exam_screen.dart';
import '../Subjects screens/subject_list_screen.dart';

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
      Get.snackbar('Error', 'Could not open dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryCtrl = Get.put(CategoryController());
    final subjectCtrl = Get.put(SubjectController());

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
                const SizedBox(height: 50),
                const Text(
                  'Avtoskola Varketilshi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Take practical training with us, Call us now',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
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
                  label: 'By Subject',
                  onPressed: () {
                    Get.to(
                      () => SubjectListScreen(),
                      arguments: {'category': idx},
                    );
                  },
                ),
                const SizedBox(height: 16),
                CommonRedButton(
                  label: 'All Tickets',
                  onPressed: () {
                    final categoryCtrl = Get.find<CategoryController>();
                    final selectedCategory = categoryCtrl.currentLabel;

                    // Register controller and pass argument only after Get.to
                    Get.to(() => TicketsScreen(), arguments: selectedCategory);
                  },
                ),
                const SizedBox(height: 16),
                CommonRedButton(
                  label: 'Exam',
                  onPressed: () {
                    final categoryCtrl = Get.find<CategoryController>();
                    final selectedCategory = categoryCtrl.currentLabel;

                    // Register controller and pass argument only after Get.to
                    Get.to(() => ExamScreen(), arguments: selectedCategory);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
