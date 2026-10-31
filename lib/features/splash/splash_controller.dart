import 'package:get/get.dart';
import '../../app/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      Get.offAllNamed(AppRoutes.navigation);
    });
  }
}