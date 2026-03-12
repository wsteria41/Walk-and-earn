class AppText {

  static String currentLang = "en";

  static Map<String, Map<String, String>> texts = {

    "en": {

      "settings": "Settings",
      "profile": "Profile",
      "dashboard": "Dashboard",
      "steps": "Steps",
      "notifications": "Notifications",
      "language": "Language",
      "darkMode": "Dark Mode",
      "logout": "Logout",
      "calories": "Calories",
      "rewards": "Rewards"

    },

    "mn": {

      "settings": "Тохиргоо",
      "profile": "Профайл",
      "dashboard": "Самбар",
      "steps": "Алхам",
      "notifications": "Мэдэгдэл",
      "language": "Хэл",
      "darkMode": "Харанхуй горим",
      "logout": "Гарах",
      "calories": "Калори",
      "rewards": "Шагнал",


    }

  };

  static String t(String key){
    return texts[currentLang]?[key] ?? key;
  }

}