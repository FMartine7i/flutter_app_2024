import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_base/helpers/theme_provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}
class _DrawerMenuState extends State<DrawerMenu> {
  bool _isExpanded = false;
  final List<Map<String, dynamic>> _menuItems = [
    {
      'route': 'home', 
      'icon': Icons.home_outlined,
      'title': 'home'
      },
    {
      'route': 'songs_list', 
      'icon': Icons.music_note,
      'title': 'songs', 
      'subtitle': 'search songs', 
      'isExpandable': true, 
      'children': [
        {'route': 'songs_list', 'title': 'all songs'},
        {'route': 'songs_by_mood', 'title': 'by mood'}
        ]
      },
    {
      'route': 'albums_list', 
      'icon': Icons.album_outlined,
      'title': 'albums', 
      'subtitle': 'search albums'},
    {
      'route': 'playlists_list', 
      'icon': Icons.playlist_play,
      'title': 'playlists', 
      'subtitle': 'search playlists'},
    {
      'route': 'profile',
      'icon': Icons.account_circle_outlined, 
      'title': 'profile'
      },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeaderAlternative(),
          ..._menuItems.map((item) {
            final bool isExpandable = item['isExpandable'] ?? false;

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric( vertical: 0, horizontal: 10 ),
                  dense: true,
                  minLeadingWidth: 25,
                  iconColor: Colors.deepPurpleAccent,
                  leading: Icon(item['icon']),
                  title: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [Text(item['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (item['subtitle'] != null) Text(item['subtitle'], style: const TextStyle(fontSize: 14, color: Colors.grey))]
                  ),
                  trailing: isExpandable ? AnimatedRotation( turns: _isExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: const Icon(Icons.arrow_drop_down)): null,
                  onTap: () {
                    if (isExpandable) { setState(() { _isExpanded = !_isExpanded; }); }
                    else {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, item['route']!);
                    }
                  },
                ),
                if (isExpandable && _isExpanded)
                  ...item['children']!.map<Widget>((child) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: ListTile(
                        dense: true,
                        title: Text(child['title'], style: const TextStyle(fontSize: 16)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, child['route']!);
                        }
                      )  
                    );
                  })
              ]
            );
          }
        ),
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
  const _DrawerHeaderAlternative({super.key});

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
