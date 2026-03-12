import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';

import '../../../core/localization/language_controller.dart';
import '../../../core/localization/app_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final languageController = Provider.of<LanguageController>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text(AppText.t("settings")),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// DARK MODE
          SwitchListTile(
            title: Text(AppText.t("darkMode")),
            value: themeProvider.isDark,
            onChanged: (v){
              themeProvider.toggleTheme(v);
            },
          ),

          /// NOTIFICATIONS
          SwitchListTile(
            title: Text(AppText.t("notifications")),
            value: notificationProvider.enabled,
            onChanged: (v){
              notificationProvider.toggle(v);
            },
          ),

          /// LANGUAGE
          ListTile(
            title: Text(AppText.t("language")),
            subtitle: Text(
              AppText.currentLang == "en"
                  ? "English"
                  : "Монгол"
            ),

            onTap: (){

              showDialog(
                context: context,
                builder: (context){

                  return AlertDialog(

                    title: Text(AppText.t("language")),

                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        ListTile(
                          title: const Text("English"),
                          onTap: (){
                            languageController.setLanguage("en");
                            Navigator.pop(context);
                          },
                        ),

                        ListTile(
                          title: const Text("Монгол"),
                          onTap: (){
                            languageController.setLanguage("mn");
                            Navigator.pop(context);
                          },
                        ),

                      ],
                    ),

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