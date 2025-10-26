import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';
  
  // Supported languages - easy to extend
  static const Map<String, Locale> supportedLanguages = {
    'ka': Locale('ka', 'GE'),
    'en': Locale('en', 'US'),
    // Add more languages here easily:
    // 'ru': Locale('ru', 'RU'),
    // 'de': Locale('de', 'DE'),
  };
  
  final Rx<Locale> _locale = const Locale('ka', 'GE').obs;
  final RxString _currentLanguageCode = 'ka'.obs;
  
  Locale get locale => _locale.value;
  String get currentLanguageCode => _currentLanguageCode.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'ka';
    
    if (supportedLanguages.containsKey(languageCode)) {
      _locale.value = supportedLanguages[languageCode]!;
      _currentLanguageCode.value = languageCode;
    } else {
      _locale.value = supportedLanguages['ka']!;
      _currentLanguageCode.value = 'ka';
    }
    
    Get.updateLocale(_locale.value);
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    _locale.value = supportedLanguages[languageCode]!;
    _currentLanguageCode.value = languageCode;
    
    Get.updateLocale(_locale.value);
    update(); // Force update all GetBuilder widgets
  }
  
  // Easy language checking methods
  bool get isEnglish => _currentLanguageCode.value == 'en';
  bool get isGeorgian => _currentLanguageCode.value == 'ka';
  
  // Generic method to check any language
  bool isLanguage(String languageCode) => _currentLanguageCode.value == languageCode;
}
