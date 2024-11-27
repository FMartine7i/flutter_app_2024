import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_base/helpers/theme_provider.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home', 'subtitle': 'Home + counter app'},
    {'route': 'custom_list', 'title': 'Songs', 'subtitle': ''},
    {'route': 'profile', 'title': 'Perfil usuario', 'subtitle': ''},
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
          ...ListTile.divideTiles(
              context: context,
              tiles: _menuItems
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        dense: true,
                        minLeadingWidth: 25,
                        iconColor: Colors.blueGrey,
                        title: Text(item['title']!,
                            style: const TextStyle(fontFamily: 'FuzzyBubbles')),
                        subtitle: Text(item['subtitle'] ?? '',
                            style: const TextStyle(
                                fontFamily: 'RobotoMono', fontSize: 11)),
                        leading: const Icon(Icons.arrow_right),
                        /* trailing: const Icon(Icons.arrow_right), */
                        onTap: () {
                          Navigator.pop(context);
                          //Navigator.pushReplacementNamed(context, item['route']!);
                          Navigator.pushNamed(context, item['route']!);
                        },
                      ))
                  .toList()),
                  ListTile(
                    title: const Text('Dark mode'),
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
  const _DrawerHeaderAlternative({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Positioned(
          top: -90,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 139, 30, 185).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.2),
          ),
        ),
        Positioned(
          top: 70,
          right: -10,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            '[  Menu  ]',
            style: TextStyle(
                fontSize: 13, color: Colors.black54, fontFamily: 'RobotoMono'),
            textAlign: TextAlign.right,
          ),
        ),
      ]),
    );
  }
}
