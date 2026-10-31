import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_template/core/theme/theme_controller.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(() => ThemeController(), fenix: true);
  await AppConfig.load();
  await AdService.initialize();
  runApp(const App());
}