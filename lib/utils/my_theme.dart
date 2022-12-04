import 'package:flutter/material.dart';
import 'package:to_do_app_rw/utils/constants.dart';

MyTheme currentTheme = MyTheme();

class MyTheme with ChangeNotifier {
  static bool isDark = false;

  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

ThemeData lightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: GetColors.black,
      appBarTheme: const AppBarTheme(backgroundColor: GetColors.white),
      iconTheme: const IconThemeData(color: GetColors.black),
      textTheme: const TextTheme().copyWith(
          headline2: const TextStyle(
              fontSize: 18, color: GetColors.black, fontWeight: FontWeight.w500),
          bodyText1: const TextStyle(fontSize: 13, color: GetColors.black,fontWeight: FontWeight.normal)),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: GetColors.white));
}

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: GetColors.white,
      appBarTheme: const AppBarTheme(backgroundColor: GetColors.black),
      iconTheme: const IconThemeData(color: GetColors.white),
      textTheme: const TextTheme().copyWith(
          headline2: const TextStyle(
              fontSize: 18, color: GetColors.white, fontWeight: FontWeight.w500),
          bodyText1: const TextStyle(fontSize: 13, color: GetColors.white,fontWeight: FontWeight.normal)),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: GetColors.yellow));
}
