import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_template/core/config/const.dart';
import '../../app/app_routes.dart';
import '../../core/config/app_config.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: Const.enableSidebar
          ? AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ) : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader('App Settings', theme),
          _buildSettingItem(context, Icons.history, 'History', onTap: controller.goToHistory),
          _buildSettingItem(context, Icons.palette, 'Theme', onTap: controller.changeTheme),
          const SizedBox(height: 30),
          _buildSectionHeader('Support', theme),
          _buildSettingItem(context, Icons.share, 'Share App', onTap: controller.shareApp),
          _buildSettingItem(context, Icons.star, 'Rate App', onTap: controller.rateApp),
          const SizedBox(height: 30),
          _buildSectionHeader('Legal', theme),
          _buildSettingItem(context, Icons.privacy_tip, 'Privacy Policy', onTap: controller.openPrivacyPolicy),
          _buildSettingItem(context, Icons.description, 'Terms & Conditions', onTap: controller.openTermsConditions),
          _buildSettingItem(context, Icons.email, 'Contact Us', onTap: controller.openContact),
          const SizedBox(height: 40),
          Center(
            child: Text(
              Const.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
          ),
          Center(
            child: Text(
              'Version : ${Const.version}',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context,
      IconData leadingIcon,
      String title, {
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: theme.cardColor,
      elevation: isDark ? 2 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(leadingIcon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withAlpha(150),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}