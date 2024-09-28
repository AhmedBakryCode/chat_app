import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/themes/dark_mode.dart';
import 'package:vqa_graduation_project/themes/light_mode.dart';

class ThemesProvider extends ChangeNotifier {

  ThemeData _themeMode = LightMode;
ThemeData get themeData => _themeMode;

  bool get isDarkMode => _themeMode == DarkMode;

  void toggleTheme(bool isOn) {
         
    _themeMode = isOn ? DarkMode: LightMode;
    notifyListeners();
  }

 

  ThemeData get currentThemeMode => _themeMode;

  ThemeData get currentTheme => _themeMode == ThemeMode.dark
      ? ThemeData.dark()
      : ThemeData.light();

  ColorScheme get currentColorScheme => _themeMode == ThemeMode.dark
      ? ColorScheme.dark()
      : ColorScheme.light();  

  Color get primaryColor => _themeMode == ThemeMode.dark
      ? Colors.grey.shade800
      : Colors.grey.shade200;

  Color get secondaryColor => _themeMode == ThemeMode.dark 
      ? Colors.grey.shade600
      : Colors.grey.shade300;

  Color get tertiaryColor => _themeMode == ThemeMode.dark  
      ? Colors.grey.shade700
      : Colors.grey.shade400;

  Color get inversePrimaryColor => _themeMode == ThemeMode.dark  
      ? Colors.grey.shade300
      : Colors.grey.shade700;



  
}