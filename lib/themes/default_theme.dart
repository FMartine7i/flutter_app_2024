import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primaryLight = Color.fromARGB(255, 174, 42, 210);
  static const Color primaryDark = Color.fromARGB(255, 142, 49, 235);
  static const Color secondary = Colors.grey;
  static const Color formElementsColor = Colors.purple;
  static const Color primaryHover =  Color.fromARGB(255, 174, 42, 210);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: primaryLight, foregroundColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(style: TextButton.styleFrom(
      backgroundColor: primaryLight, foregroundColor: Colors.black)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: primaryLight, foregroundColor: Colors.black)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.black,
      ),
      listTileTheme: const ListTileThemeData(iconColor: primaryLight), 
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: formElementsColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ))
    );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 161, 50, 212), foregroundColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: primaryDark, foregroundColor: Colors.white)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: secondary, foregroundColor: Colors.white)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(iconColor: primaryDark),
      /* switchTheme: SwitchThemeData(), */
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: formElementsColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )));
}
