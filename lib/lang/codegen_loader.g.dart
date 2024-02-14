// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ru = {
  "title": "Валюта",
  "calculate": "Рассчитать",
  "uzbek": "Узбекский",
  "english": "Английский",
  "russian": "Русский"
};
static const Map<String,dynamic> en = {
  "title": "Currency",
  "calculate": "Calculate",
  "uzbek": "Uzbek",
  "english": "English",
  "russian": "Russian"
};
static const Map<String,dynamic> uz = {
  "title": "Valyuta",
  "calculate": "Hisoblash",
  "uzbek": "O`zbekcha",
  "english": "Ingilizcha",
  "russian": "Ruscha"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ru": ru, "en": en, "uz": uz};
}
