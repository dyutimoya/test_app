import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/app_routes.dart';
import 'const.dart';

class AppConfig {

  static Future<void> load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    Const.appName = packageInfo.appName;
    Const.version = packageInfo.version;
    Const.packageName = packageInfo.packageName;
    Const.appUrl = "https://apps.samsung.com/appquery/appDetail.as?appId=${packageInfo.packageName}";
  }

  // Utility Functions
  static Future<void> shareApp() async {
    final String message = "${Const.shareMessage}\n\n${Const.appUrl}";
    await SharePlus.instance.share(
      ShareParams(text: message, subject: Const.appName),
    );
  }

  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  static void openPrivacyPolicy() {
    Get.toNamed(AppRoutes.webview, arguments: {
      'url': Const.privacyPolicyUrl,
      'title': 'Privacy Policy',
    });
  }

  static void openTermsConditions() {
    Get.toNamed(AppRoutes.webview, arguments: {
      'url': Const.termsConditionsUrl,
      'title': 'Terms & Conditions',
    });
  }
}