

import 'package:flutter/material.dart';
import 'package:note_app/themes/theme.dart';

class ThemeProvider extends ChangeNotifier {
  //initially theme is light moder
   ThemeData _themeData = lightMode;
   
   // getter method to access the theme from other files
   ThemeData get themeData => _themeData;

   bool get isDarkMode => _themeData == darkMode;

   set themeData(ThemeData themeData) {
     _themeData = themeData;
     notifyListeners();
   }

   void toggleTheme() {
     if (_themeData == lightMode) {
       themeData = darkMode;
     } else {
       themeData = lightMode;
     }
     notifyListeners();
   }
 }