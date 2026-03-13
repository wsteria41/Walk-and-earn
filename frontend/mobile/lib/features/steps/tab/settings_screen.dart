import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../core/localization/language_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageController>();
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// APPEARANCE SECTION
          const Text(
            "Appearance",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              value: themeProvider.isDark,
              onChanged: (v) {
                themeProvider.toggleTheme(v);
              },
            ),
          ),

          const SizedBox(height: 25),

          /// NOTIFICATIONS SECTION
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text("Enable Notifications"),
              value: notificationProvider.enabled,
              onChanged: (v) {
                notificationProvider.toggle(v);
              },
            ),
          ),

          const SizedBox(height: 25),

          /// LANGUAGE SECTION
          const Text(
            "Language",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text("App Language"),
              subtitle: Text(
                languageProvider.locale.languageCode == "en"
                    ? "English"
                    : "Монгол",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showLanguagePicker(context, languageProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, LanguageController languageProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 10),

                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Choose Language",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                  title: const Text("English"),
                  onTap: () {
                    languageProvider.setLanguage("en");
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Text("🇲🇳", style: TextStyle(fontSize: 20)),
                  title: const Text("Монгол"),
                  onTap: () {
                    languageProvider.setLanguage("mn");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}