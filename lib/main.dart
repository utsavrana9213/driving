import 'package:avtoskola_varketilshi/App%20Screens/splash_screen.dart';
import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Models/unanswered_questions_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(UnansweredQuestionsModelAdapter().typeId)) {
    Hive.registerAdapter(UnansweredQuestionsModelAdapter());
  }

  if (!Hive.isAdapterRegistered(ExamQuestionModelAdapter().typeId)) {
    Hive.registerAdapter(ExamQuestionModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Avtoskola Varketilshi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xffFFFFFF),
      ),
      home: SplashScreen(),
    );
  }
}
