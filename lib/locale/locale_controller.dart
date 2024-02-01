import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';

class MyLocaleController extends GetxController {
  Locale initialLang = sharedPref!.getString('lang') == null
      ? Get.deviceLocale!
      : Locale(sharedPref!.getString('lang')!);

  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    sharedPref!.setString('lang', codeLang);
    Get.updateLocale(locale);
  }
}
