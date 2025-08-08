import 'dart:convert';
import 'dart:developer';

import 'package:avtoskola_varketilshi/Models/question_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SubjectController extends GetxController {
  // All categories share the same subjects
  final subjects = <SubjectModel>[
    SubjectModel(
        id: 1, title: '1.მძღოლი, მგზავრი და ქვეითი, ნიშნები, კონვეცია'),
    SubjectModel(id: 2, title: '2.უწესივრობა და მართვის პირობები'),
    SubjectModel(id: 3, title: '3.მაფრთხილებელი ნიშნები'),
    SubjectModel(id: 4, title: '4.პრიორიტეტის ნიშნები'),
    SubjectModel(id: 5, title: '5.ამკრძალავი ნიშნები'),
    SubjectModel(id: 6, title: '6.მიმთითებელი ნიშნები'),
    SubjectModel(id: 7, title: '7.საინფორმაციო-მაჩვენებელი ნიშნები'),
    SubjectModel(id: 8, title: '8.სერვისის ნიშნები'),
    SubjectModel(id: 9, title: '9.დამატებითი ინფორმაციის ნიშნები'),
    SubjectModel(id: 10, title: '10.შუქნიშნის სიგნალები'),
    SubjectModel(id: 11, title: '11.მარეგულირებლის სიგნალები'),
    SubjectModel(id: 12, title: '12.სპეციალური სიგნალის გამოყენება'),
    SubjectModel(id: 13, title: '13.საავარიო შუქური სიგნალიზაცია'),
    SubjectModel(id: 14, title: '14.სანათი ხელსაწყოები, ხმოვანი სიგნალი'),
    SubjectModel(id: 15, title: '15.მოძრაობა, მანევრირება, სავალი ნაწილი'),
    SubjectModel(id: 16, title: '16.გასწრება შემხვედრის გვერდის ავლით'),
    SubjectModel(id: 17, title: '17.მოძრაობის სიჩქარე'),
    SubjectModel(id: 18, title: '18.სამუხრუჭე მანძილი, დისტანცია'),
    SubjectModel(id: 19, title: '19.გაჩერება დგომა'),
    SubjectModel(id: 20, title: '20.გზაჯვარედინის გავლა'),
    SubjectModel(id: 21, title: '21.რკინიგზის გადასასვლელი'),
    SubjectModel(id: 22, title: '22.მოძრაობა ავტომაგისტრალზე'),
    SubjectModel(id: 23, title: '23.საცხოვრებელი ზონა, სამარშრუტოს პრიორიტეტი'),
    SubjectModel(id: 24, title: '24.ბუქსირება'),
    SubjectModel(id: 25, title: '25.სასწავლო სვლა'),
    SubjectModel(id: 26, title: '26.გადაზიდვები, ხალხი, ტვირთი'),
    SubjectModel(id: 27, title: '27.ველოსიპედი, მოპედი და პირუტყვის გადარეკვა'),
    SubjectModel(id: 28, title: '28.საგზაო მონიშვნა'),
    SubjectModel(id: 29, title: '29.სამედიცინო დახმარება'),
    SubjectModel(id: 30, title: '30.მოძრაობის უსაფრთხოება'), 
    SubjectModel(id: 31, title: '31.ადმინისტრაციული კანონი'),
    SubjectModel(id: 32, title: '32.ეკო-მართვა[ახალი]'),
  ].obs;

  /// Questions by category and subject
  /// categoryId -> subjectId -> List<QuestionModel
  final Map<int, Map<int, List<QuestionModel>>> categorySubjectQuestions = {};

  /// Loading state
  final RxBool isLoading = true.obs;

  /// Map of categoryId -> subjectId -> file path
  final Map<int, Map<int, String>> questionFilePaths = {
    0: {
      1: 'assets/questions/b-b1/bb1_sign_conventions.json',
      2: 'assets/questions/b-b1/bb1_driving_conditions.json',
      3: 'assets/questions/b-b1/bb1_warning_signs.json',
      4: 'assets/questions/b-b1/bb1_priority_signs.json',
      5: 'assets/questions/b-b1/bb1_prohobitory_signs.json',
      6: 'assets/questions/b-b1/bb1_indicative_signs.json',
      7: 'assets/questions/b-b1/bb1_information_signs.json',
      8: 'assets/questions/b-b1/bb1_service_marks.json',
      9: 'assets/questions/b-b1/bb1_additional_info.json',
      10: 'assets/questions/b-b1/bb1_traffic_signals.json',
      11: 'assets/questions/b-b1/bb1_regulator_signs.json',
      12: 'assets/questions/b-b1/bb1_spcl_signs_use.json',
      13: 'assets/questions/b-b1/bb1_emergency_signal.json',
      14: 'assets/questions/b-b1/bb1_light_and_sound.json',
      15: 'assets/questions/b-b1/bb1_maneuvering.json',
      16: 'assets/questions/b-b1/bb1_overtaking.json',
      17: 'assets/questions/b-b1/bb1_movement_speed.json',
      18: 'assets/questions/b-b1/bb1_distance.json',
      19: 'assets/questions/b-b1/bb1_stop_standing.json',
      20: 'assets/questions/b-b1/bb1_intersection.json',
      21: 'assets/questions/b-b1/bb1_railway_crossing.json',
      22: 'assets/questions/b-b1/bb1_highway_traffic.json',
      23: 'assets/questions/b-b1/bb1_residential_zone.json',
      24: 'assets/questions/b-b1/bb1_towing.json',
      25: 'assets/questions/b-b1/bb1_learning_move.json',
      26: 'assets/questions/b-b1/bb1_shipment.json',
      27: 'assets/questions/b-b1/bb1_bicycle.json',
      28: 'assets/questions/b-b1/bb1_road_marking.json',
      29: 'assets/questions/b-b1/bb1_medical.json',
      30: 'assets/questions/b-b1/bb1_traffic_safety.json',
      31: 'assets/questions/b-b1/bb1_law.json',
      32: 'assets/questions/b-b1/bb1_eco_driving.json'
      //category 0
    },
    1: {
      1: 'assets/questions/c/c_sign_conventions.json',
      2: 'assets/questions/c/c_driving_conditions.json',
      3: 'assets/questions/c/c_warning_signs.json',
      4: 'assets/questions/c/c_priority_signs.json',
      5: 'assets/questions/c/c_prohobitory_signs.json',
      6: 'assets/questions/c/c_indicative_signs.json',
      7: 'assets/questions/c/c_information_signs.json',
      8: 'assets/questions/c/c_service_marks.json',
      9: 'assets/questions/c/c_additional_info.json',
      10: 'assets/questions/c/c_traffic_signals.json',
      11: 'assets/questions/c/c_regulator_signs.json',
      12: 'assets/questions/c/c_spcl_signs_use.json',
      13: 'assets/questions/c/c_emergency_signal.json',
      14: 'assets/questions/c/c_light_and_sound.json',
      15: 'assets/questions/c/c_maneuvering.json',
      16: 'assets/questions/c/c_overtaking.json',
      17: 'assets/questions/c/c_movement_speed.json',
      18: 'assets/questions/c/c_distance.json',
      19: 'assets/questions/c/c_stop_standing.json',
      20: 'assets/questions/c/c_intersection.json',
      21: 'assets/questions/c/c_railway_crossing.json',
      22: 'assets/questions/c/c_highway_traffic.json',
      23: 'assets/questions/c/c_residential_zone.json',
      24: 'assets/questions/c/c_towing.json',
      25: 'assets/questions/c/c_learning_move.json',
      26: 'assets/questions/c/c_shipment.json',
      27: 'assets/questions/c/c_bicycle.json',
      28: 'assets/questions/c/c_road_marking.json',
      29: 'assets/questions/c/c_medical.json',
      30: 'assets/questions/c/c_traffic_safety.json',
      31: 'assets/questions/c/c_law.json',
      32: 'assets/questions/c/c_eco_driving.json'
      //  category 1
    },
    2: {
      1: 'assets/questions/d/d_sign_conventions.json',
      2: 'assets/questions/d/d_driving_conditions.json',
      3: 'assets/questions/d/d_warning_signs.json',
      4: 'assets/questions/d/d_priority_sign.json',
      5: 'assets/questions/d/d_prohobitory_signs.json',
      6: 'assets/questions/d/d_indicative_signs.json',
      7: 'assets/questions/d/d_information_signs.json',
      8: 'assets/questions/d/d_service_marks.json',
      9: 'assets/questions/d/d_additional_info.json',
      10: 'assets/questions/d/d_traffic_signals.json',
      11: 'assets/questions/d/d_regulator_signs.json',
      12: 'assets/questions/d/d_spcl_signs_use.json',
      13: 'assets/questions/d/d_emergency_signal.json',
      14: 'assets/questions/d/d_light_and_sound.json',
      15: 'assets/questions/d/d_maneuvering.json',
      16: 'assets/questions/d/d_overtaking.json',
      17: 'assets/questions/d/d_movement_speed.json',
      18: 'assets/questions/d/d_distance.json',
      19: 'assets/questions/d/d_stop_standing.json',
      20: 'assets/questions/d/d_intersection.json',
      21: 'assets/questions/d/d_railway_crossing.json',
      22: 'assets/questions/d/d_highway_traffic.json',
      23: 'assets/questions/d/d_residential_zone.json',
      24: 'assets/questions/d/d_towing.json',
      25: 'assets/questions/d/d_learning_move.json',
      26: 'assets/questions/d/d_shipment.json',
      27: 'assets/questions/d/d_bicycle.json',
      28: 'assets/questions/d/d_road_marking.json',
      29: 'assets/questions/d/d_medical.json',
      30: 'assets/questions/d/d_traffic_safety.json',
      31: 'assets/questions/d/d_law.json',
      32: 'assets/questions/d/d_eco_driving.json'
      //  category 2
    },
    3: {
      1: 'assets/questions/t-s/ts_sign_conventions.json',
      2: 'assets/questions/t-s/ts_driving_conditions.json',
      3: 'assets/questions/t-s/ts_warning_signs.json',
      4: 'assets/questions/t-s/ts_priority_sign.json',
      5: 'assets/questions/t-s/ts_prohobitory_signs.json',
      6: 'assets/questions/t-s/ts_indicative_signs.json',
      7: 'assets/questions/t-s/ts_information_signs.json',
      8: 'assets/questions/t-s/ts_service_marks.json',
      9: 'assets/questions/t-s/ts_additional_info.json',
      10: 'assets/questions/t-s/ts_traffic_signals.json',
      11: 'assets/questions/t-s/ts_regulator_signs.json',
      12: 'assets/questions/t-s/ts_spcl_signs_use.json',
      13: 'assets/questions/t-s/ts_emergency_signal.json',
      14: 'assets/questions/t-s/ts_light_and_sound.json',
      15: 'assets/questions/t-s/ts_maneuvering.json',
      16: 'assets/questions/t-s/ts_overtaking.json',
      17: 'assets/questions/t-s/ts_movement_speed.json',
      18: 'assets/questions/t-s/ts_distance.json',
      19: 'assets/questions/t-s/ts_stop_standing.json',
      20: 'assets/questions/t-s/ts_intersection.json',
      21: 'assets/questions/t-s/ts_railway_crossing.json',
      22: 'assets/questions/t-s/ts_highway_traffic.json',
      23: 'assets/questions/t-s/ts_residential_zone.json',
      24: 'assets/questions/t-s/ts_towing.json',
      25: 'assets/questions/t-s/ts_learning_move.json',
      26: 'assets/questions/t-s/ts_shipment.json',
      27: 'assets/questions/t-s/ts_bicycle.json',
      28: 'assets/questions/t-s/ts_road_marking.json',
      29: 'assets/questions/t-s/ts_medical.json',
      30: 'assets/questions/t-s/ts_traffic_safety.json',
      31: 'assets/questions/t-s/ts_law.json',
      32: 'assets/questions/t-s/ts_eco_driving.json'
      //  category 3
    },
  };

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<List<QuestionModel>> loadSubjectQuestions(String questionFile) async {
    try {
      final String jsonString = await rootBundle.loadString(questionFile);
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .map((questionJson) => QuestionModel.fromJson(questionJson))
          .toList();
    } catch (e) {
      log("Error loading questions: $e");
      return [];
    }
  }

  Future<void> loadQuestions() async {
    isLoading.value = true;
    final categories = questionFilePaths.keys;
    for (final categoryId in categories) {
      categorySubjectQuestions[categoryId] = {};
      final subjectMap = questionFilePaths[categoryId]!;
      for (final subjectId in subjectMap.keys) {
        final filePath = subjectMap[subjectId]!;
        try {
          final questions = await loadSubjectQuestions(filePath);
          categorySubjectQuestions[categoryId]![subjectId] = questions;
        } catch (e) {
          categorySubjectQuestions[categoryId]![subjectId] = [];
        }
      }
    }
    isLoading.value = false;
  }

  List<SubjectModel> getSubjects() => subjects;

  List<QuestionModel> getQuestionsForSubject(int categoryId, int subjectId) {
    if (isLoading.value) return [];
    return categorySubjectQuestions[categoryId]?[subjectId] ?? [];
  }
}
