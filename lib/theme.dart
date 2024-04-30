import 'package:flutter/material.dart';

abstract class AppTheme {
  static TextStyle defaultTitleText = const TextStyle(
      fontSize: 23, fontWeight: FontWeight.w600, color: AppColors.primaryColor);

  static TextStyle defaultItemText = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textColor);

  static ThemeData lightTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        primaryColor: AppColors.primaryColor,
        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(AppColors.primaryColor))),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 51, 51, 51))),
        ));
  }
}

abstract class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 0, 0, 0);
  static const Color buttonsColor = Color.fromARGB(255, 116, 116, 116);
  static const Color textColor = Color.fromARGB(255, 59, 59, 59);
}
