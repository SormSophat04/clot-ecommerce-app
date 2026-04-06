import 'package:get/get.dart';

class SplashController extends GetxController {
  final selectedGender = 'Men'.obs;
  final selectedAgeRange = 'Age Range'.obs;

  final List<String> ageRanges = [
    'Under 18',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55+',
  ];

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setAgeRange(String ageRange) {
    selectedAgeRange.value = ageRange;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Currently used for onboarding setup, so we do not auto-navigate here
  }
}

