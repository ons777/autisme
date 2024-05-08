import 'package:get/get.dart';
import 'ar.dart';
import 'fr.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "fr": fr,
        "ar": ar,
      };
}
