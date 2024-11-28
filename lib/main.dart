import 'package:flutter/material.dart';
import 'package:flutter_application_base/helpers/preferences.dart';
import 'package:flutter_application_base/screens/screens.dart';
import 'package:flutter_application_base/helpers/theme_provider.dart';
import 'package:flutter_application_base/themes/default_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child){
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            initialRoute: 'home',
            theme: DefaultTheme.lightTheme,
            darkTheme: DefaultTheme.darkTheme,
            themeMode: Preferences.darkmode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              'home': (context) => const HomeScreen(),
              'songs_list': (context) => const SongsListScreen(),
              'profile': (context) => const ProfileScreen(),
              'songs_list_item': (context) => const CustomListItem(),
          });
        }
      )  
    );
  }
}
