import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../core/localization/language_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// DARK MODE
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (v){
              themeProvider.toggleTheme(v);
            },
          ),

          /// NOTIFICATIONS
          SwitchListTile(
            title: const Text("Notifications"),
            value: notificationProvider.enabled,
            onChanged: (v){
              notificationProvider.toggle(v);
            },
          ),

          /// LANGUAGE
          ListTile(
            title: const Text("Language"),
            subtitle: Text(
              languageProvider.locale.languageCode == "en"
                  ? "English"
                  : "Монгол"
            ),

            onTap: (){

              showModalBottomSheet(
                context: context,
                builder: (_) {

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      ListTile(
                        title: const Text("English"),
                        onTap: (){
                          languageProvider.setLanguage("en");
                          Navigator.pop(context);
                        },
                      ),

                      ListTile(
                        title: const Text("Монгол"),
                        onTap: (){
                          languageProvider.setLanguage("mn");
                          Navigator.pop(context);
                        },
                      ),

                    ],
                  );

                },
              );

            },
          ),

        ],
      ),
    );
  }
}