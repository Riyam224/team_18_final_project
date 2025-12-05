import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  final String languageCode;
  const LanguageState(this.languageCode);
}

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'app_language_code';

  LanguageCubit() : super(const LanguageState('en')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_languageKey) ?? 'en';
    emit(LanguageState(savedLang));
  }

  Future<void> changeLanguage(String newCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, newCode);
    
    emit(LanguageState(newCode)); 
  }
}