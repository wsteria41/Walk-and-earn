import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../core/localization/language_controller.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final languageController = context.watch<LanguageController>();
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l.settings),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// NOTIFICATIONS
          Text(
            l.notifications.toUpperCase(),
            style: const TextStyle(
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
              title: Text(
                l.notifications,
                style: const TextStyle(color: Colors.white),
              ),
              value: notificationProvider.enabled,
              onChanged: (v) => notificationProvider.toggle(v),
            ),
          ),

          const SizedBox(height: 25),

          /// LANGUAGE
          Text(
            l.language.toUpperCase(),
            style: const TextStyle(
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
              title: Text(
                l.language,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                languageController.locale.languageCode == "en"
                    ? "English"
                    : "Монгол",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () => _showLanguagePicker(context, languageController),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, LanguageController languageController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1f2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  trailing: languageController.locale.languageCode == "en"
                      ? const Icon(Icons.check, color: Color(0xFF7B2FFF))
                      : null,
                  onTap: () {
                    languageController.setLanguage("en");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Text("🇲🇳", style: TextStyle(fontSize: 20)),
                  title: const Text(
                    "Монгол",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: languageController.locale.languageCode == "mn"
                      ? const Icon(Icons.check, color: Color(0xFF7B2FFF))
                      : null,
                  onTap: () {
                    languageController.setLanguage("mn");
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
