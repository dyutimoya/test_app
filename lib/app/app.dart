import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_template/core/config/const.dart';
import 'package:my_template/core/theme/theme_controller.dart';
import '../core/theme/app_theme.dart';
import 'app_bindings.dart';
import 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() =>
        GetMaterialApp(
          title: Const.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          initialBinding: AppBindings(),
          initialRoute: AppRoutes.navigation,
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
        )
    );
  }
}