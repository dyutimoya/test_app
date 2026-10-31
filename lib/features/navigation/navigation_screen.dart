import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_template/core/config/const.dart';
import 'package:my_template/widgets/theme_dialog.dart';
import '../../app/app_routes.dart';
import '../../core/config/app_config.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import 'navigation_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final screens = const [HomeScreen(), HistoryScreen(), SettingsScreen()];
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(() {
      final isHome = controller.currentIndex.value == 0;
      return Scaffold(
        key: scaffoldKey,
        appBar: isHome ? AppBar(
          title: Text(Const.appName),
          leading: Const.enableSidebar
              ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ) : null,
        ) : null,
        drawer: Const.enableSidebar && isHome
            ? _buildDrawer(context, controller)
            : null,
        body: Column(
          children: [
            Expanded(child: screens[controller.currentIndex.value]),
          ],
        ),
        bottomNavigationBar: Const.enableBottomNavigation
            ? BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ) : null,
      );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, NavigationController controller) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withAlpha(205),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha(75),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/icon.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white.withAlpha(50),
                        child: const Icon(
                          Icons.apps_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Const.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', 0, controller),
          _buildDrawerItem(Icons.history, 'History', 1, controller, onTap: () => Get.toNamed(AppRoutes.history)),
          const Divider(),
          _buildDrawerSectionHeader('App Settings'),
          _buildDrawerItem(Icons.palette, 'Theme', -3, controller, onTap: ThemeDialog.show),
          const Divider(),
          _buildDrawerSectionHeader('Support'),
          _buildDrawerItem(Icons.share, 'Share App', -5, controller, onTap: AppConfig.shareApp),
          _buildDrawerItem(Icons.star, 'Rate App', -6, controller, onTap: () => AppConfig.openUrl(Const.appUrl)),
          const Divider(),
          _buildDrawerSectionHeader('Legal'),
          _buildDrawerItem(Icons.privacy_tip, 'Privacy Policy', -1, controller, onTap: AppConfig.openPrivacyPolicy),
          _buildDrawerItem(Icons.description, 'Terms & Conditions', -2, controller, onTap: AppConfig.openTermsConditions),
          _buildDrawerItem(Icons.email, 'Contact Us', -7, controller, onTap: () => AppConfig.openUrl(Const.contactUrl)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Version: ${Const.version}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withAlpha(125),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon,
      String title,
      int index,
      NavigationController controller, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(Get.context!);
        if (onTap != null) {
          onTap();
        } else if (index >= 0) {
          controller.changeTab(index);
        }
      },
    );
  }
}