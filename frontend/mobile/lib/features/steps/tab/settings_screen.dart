
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/notification_provider.dart';
import '../../../core/localization/language_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageController>();
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// NOTIFICATIONS
          const Text(
            "Notifications",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xff1f2937),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications, color: Colors.white),
              title: const Text(
                "Enable Notifications",
                style: TextStyle(color: Colors.white),
              ),
              value: notificationProvider.enabled,
              onChanged: (v) {
                notificationProvider.toggle(v);
              },
            ),
          ),

          const SizedBox(height: 25),

          /// LANGUAGE
          const Text(
            "Language",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xff1f2937),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: const Text(
                "App Language",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                languageProvider.locale.languageCode == "en"
                    ? "English"
                    : "Монгол",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
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
      backgroundColor: const Color(0xff1f2937),
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
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Choose Language",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                  title: const Text(
                    "English",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    languageProvider.setLanguage("en");
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Text("🇲🇳", style: TextStyle(fontSize: 20)),
                  title: const Text(
                    "Монгол",
                    style: TextStyle(color: Colors.white),
                  ),
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

