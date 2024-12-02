import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_base/helpers/theme_provider.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home'},
    {'route': 'custom_list', 'title': 'Songs', 'subtitle': 'search songs'},
    {'route': 'albums_list', 'title': 'Albums', 'subtitle': 'search albums'},
    {'route': 'playlists_list', 'title': 'Playlists', 'subtitle': 'search playlists'},
    {'route': 'profile', 'title': 'Profile', 'subtitle': ''},
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeaderAlternative(),
          ..._menuItems.map((item) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 10),
                dense: true,
                minLeadingWidth: 25,
                iconColor: Colors.deepPurpleAccent,
                title: Text(item['title']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text(item['subtitle'] ?? '',
                    style: const TextStyle(fontSize: 12)),
                leading: const Icon(Icons.arrow_right),
                /* trailing: const Icon(Icons.arrow_right), */
                onTap: () {
                  Navigator.pop(context);
                  //Navigator.pushReplacementNamed(context, item['route']!);
                  Navigator.pushNamed(context, item['route']!);
                },
              )),
            ListTile(
              title: const Text('dark mode'),
              trailing: Switch(
                value: themeProvider.isDarkmode,
                onChanged: (value) {
                  themeProvider.toggleTheme();  // Cambia el tema
                },
            )
          ),
        ],
      ),
    );
  }
}

class _DrawerHeaderAlternative extends StatelessWidget {
  const _DrawerHeaderAlternative();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/moodify_logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
