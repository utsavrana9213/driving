import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Subjects%20screens/subject_detail_screen.dart';
import 'package:avtoskola_varketilshi/App%20Widegts/subject_button.dart';
import 'package:avtoskola_varketilshi/Controllers/Subject%20Controllers/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class SubjectListScreen extends StatelessWidget {
//   const SubjectListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final subjectController = Get.put(SubjectController());
//     final args = Get.arguments as Map;
//     final categoryId = args['category'] as int;
//     final filteredSubjects = subjectController.getSubjectsByCategory(categoryId);


//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Top bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                           onTap: () {
//                             Get.to(HomeScreen());
//                           },
//                     child: Image.asset('assets/images/menu.png', height: 24)), // Replace with your left icon
//                   Image.asset('assets/images/logo.png', height: 30),   // Replace with your center logo
//                   Image.asset('assets/images/drawer.png', height: 24), // Replace with your right icon
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),

//             /// List of subject buttons
//             Expanded(
//               child: Obx(() {
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: subjectController.subjects.length,
//                   itemBuilder: (context, index) {
//                     final subject = subjectController.subjects[index];
//                     return SubjectButton(
//                       title: subject.title,
//                       // onPressed: () {
//                       //   Get.to(SubjectDetailScreen());
//                       // },
//                       onPressed: () {
//                         final subject = subjectController.subjects[index];
//                         final questionList = subjectController.subjectQuestions[subject.id] ?? [];
//                         Get.to(() => SubjectDetailScreen(), arguments: questionList);
//                       },

//                     );
//                   },
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Subject Controllers/subject_controller.dart';
import '../Home Screens/HomeScreen.dart';
import 'subject_detail_screen.dart';
import '../../App Widegts/subject_button.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectController = Get.find<SubjectController>();
    final args = Get.arguments as Map<String, dynamic>;
    final int categoryId = args['category'];

    final subjects = subjectController.getSubjects();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.offAll(() => HomeScreen()),
                    child: Image.asset('assets/images/menu.png', height: 24),
                  ),
                  Image.asset('assets/images/slogo.png', height: 30),
                  Image.asset('assets/images/drawer.png', height: 24),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// List of subject buttons
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return SubjectButton(
                    title: subject.title,
                    onPressed: () {
                      final questions = subjectController.getQuestionsForSubject(categoryId, subject.id);
                      Get.to(() => const SubjectDetailScreen(), arguments: questions);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
