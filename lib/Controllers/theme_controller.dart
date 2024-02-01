import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController {
  final lightTheme = ThemeData.light();

  final darkTheme = ThemeData.dark();

  final box = GetStorage();
  final darkModeKey = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  void saveThemeData(bool isDarkMode) {
    box.write(darkModeKey, isDarkMode);
  }

  bool isSavedDarkMode() {
    return box.read(darkModeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeData(!isSavedDarkMode());
  }






















  // @override
  // void onInit() {
  //   super.onInit();
  //   loadThemeFromStorage();
  // }
  //
  // void toggleTheme() {
  //   isDarkMode.value = !isDarkMode.value;
  //   saveThemeToStorage();
  // }
  //
  // void loadThemeFromStorage() {
  //   isDarkMode.value = box.read(darkModeKey) ?? false;
  // }
  //
  // void saveThemeToStorage() {
  //   box.write(darkModeKey, isDarkMode.value);
  // }

// @override
//   void onInit() {
//     super.onInit();
//     loadThemeFromPrefs();
//   }
//
//   void toggleTheme() {
//     isDarkMode.value = !isDarkMode.value;
//     saveThemeToPrefs();
//   }
//
//   Future<void> loadThemeFromPrefs() async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
//   }
//
//   Future<void> saveThemeToPrefs() async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('isDarkMode', isDarkMode.value);
//   }
}