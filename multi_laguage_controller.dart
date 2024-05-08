import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants.dart';

import '../catsh_storage.dart';

class _LanguageModel {
  final String IsoCode;
  final String language;
  _LanguageModel({
    required this.IsoCode,
    required this.language,
  });
}

class MultiLanguageController extends GetxController {
  List<_LanguageModel> languages = [
    _LanguageModel(IsoCode: "ar", language: "العربية"),
    _LanguageModel(IsoCode: "fr", language: "french"),
  ];
  // String language = CatchStorage.get(k_langKey) ?? "en";  // delete

  Future<void> updateLocal(String value) async {
    await CatchStorage.save(k_langKey, value);
    await Get.updateLocale(Locale(value));
    update();
  }

  // void onChanged(String? value) {   // delete
  //   language = value!;
  //   updateLocal();
  //   update();
  // }
}
