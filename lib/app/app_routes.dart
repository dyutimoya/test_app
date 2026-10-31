import 'package:get/get.dart';
import '../features/splash/splash_binding.dart';
import '../features/splash/splash_screen.dart';
import '../features/navigation/navigation_binding.dart';
import '../features/navigation/navigation_screen.dart';
import '../features/home/home_binding.dart';
import '../features/home/home_screen.dart';
import '../features/history/history_binding.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_binding.dart';
import '../features/settings/settings_screen.dart';
import '../features/webview/webview_binding.dart';
import '../features/webview/webview_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const navigation = '/navigation';
  static const home = '/home';
  static const history = '/history';
  static const settings = '/settings';
  static const webview = '/webview';

  static final pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: navigation,
      page: () => const NavigationScreen(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: history,
      page: () => const HistoryScreen(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: webview,
      page: () => const WebViewScreen(),
      binding: WebViewBinding(),
    ),
  ];
}