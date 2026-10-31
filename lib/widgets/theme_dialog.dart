import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_controller.dart';

class ThemeDialog {
  ThemeDialog._();

  static void show() {
    final context = Get.context;
    if (context == null) return;

    final controller = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put(ThemeController(), permanent: true);

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
            ),
          ),
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Choose Theme',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            // Rebuild the option list when selection changes.
            content: Obx(() {
              final current = controller.themeMode.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeOption(context, controller, current,
                      ThemeMode.light, Icons.light_mode, 'Light Theme', 'Bright and clear'),
                  const SizedBox(height: 12),
                  _buildThemeOption(context, controller, current,
                      ThemeMode.dark, Icons.dark_mode, 'Dark Theme', 'Easy on the eyes'),
                  const SizedBox(height: 12),
                  _buildThemeOption(context, controller, current,
                      ThemeMode.system, Icons.phone_android, 'System Default',
                      'Follow device setting'),
                ],
              );
            }),
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildThemeOption(
      BuildContext context,
      ThemeController controller,
      ThemeMode current,
      ThemeMode mode,
      IconData icon,
      String title,
      String subtitle,
      ) {
    final theme = Theme.of(context);
    final isSelected = current == mode;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(25)
            : theme.colorScheme.surfaceContainerHighest.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withAlpha(25),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withAlpha(180),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(180),
            fontSize: 12,
          ),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withAlpha(125),
              width: 2,
            ),
          ),
          child: isSelected
              ? Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
          )
              : null,
        ),
        onTap: () async {
          await controller.setMode(mode);
          if (context.mounted) Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}