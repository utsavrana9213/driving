import 'package:avtoskola_varketilshi/App%20Screens/splash_screen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Exams%20Screens/enhanced_exam_screen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Exams%20Screens/exam_fail_screen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Exams%20Screens/exam_pass_screen.dart';
import 'package:avtoskola_varketilshi/App%20Screens/Exams%20Screens/unanswered_review_screen.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Models/unanswered_questions_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:avtoskola_varketilshi/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(UnansweredQuestionsModelAdapter().typeId)) {
    Hive.registerAdapter(UnansweredQuestionsModelAdapter());
  }

  if (!Hive.isAdapterRegistered(ExamQuestionModelAdapter().typeId)) {
    Hive.registerAdapter(ExamQuestionModelAdapter());
  }

  // Initialize language controller
  Get.put(LanguageController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Avtoskola Varketilshi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xffFFFFFF),
      ),
      locale: languageController.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ka', 'GE'),
      ],
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/enhanced-exam', page: () => const EnhancedExamScreen()),
        GetPage(name: '/exam-fail', page: () => const ExamFailScreen()),
        GetPage(name: '/exam-pass', page: () => const ExamPassScreen()),
        GetPage(name: '/unanswered-review', page: () => const UnansweredReviewScreen()),
      ],
    ));
  }
}
