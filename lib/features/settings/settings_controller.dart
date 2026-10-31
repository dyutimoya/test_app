import 'package:get/get.dart';
import 'package:my_template/core/config/const.dart';
import '../../core/config/app_config.dart';
import '../../widgets/theme_dialog.dart';
import '../navigation/navigation_controller.dart';

class SettingsController extends GetxController {
  final controller = Get.put(NavigationController());
  void changeTheme() => ThemeDialog.show();
  void shareApp() => AppConfig.shareApp();
  void rateApp() => AppConfig.openUrl(Const.appUrl);
  void openPrivacyPolicy() => AppConfig.openPrivacyPolicy();
  void openTermsConditions() => AppConfig.openTermsConditions();
  void openContact() => AppConfig.openUrl(Const.contactUrl);
  void goToHistory() {
    controller.currentIndex.value = 1;
  }
}