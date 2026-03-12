import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool darkMode = true;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          SwitchListTile(
            title: const Text("Dark Mode"),
            value: darkMode,
            onChanged: (v){
              setState(()=>darkMode = v);
            },
          ),

          SwitchListTile(
            title: const Text("Notifications"),
            value: notifications,
            onChanged: (v){
              setState(()=>notifications = v);
            },
          ),

          ListTile(
            title: const Text("Language"),
            trailing: const Text("English"),
            onTap: (){},
          )

        ],
      ),
    );
  }
}