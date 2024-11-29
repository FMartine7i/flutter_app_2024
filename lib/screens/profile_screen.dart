import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_base/mocks/albumes_mock.dart'
    show elementos;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String _username = "Usuario";
  List<String> _playlists = [];
  List<Map<String, dynamic>> _favoriteAlbums = [];
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username') ?? "Usuario";
      _playlists = prefs.getStringList('playlists') ?? [];

      // Cargar los albumes favoritos como una lista de mapas con nombre e imagen

      List<String>? favoriteAlbums = prefs.getStringList('favoriteAlbums');
      if (favoriteAlbums != null) {
        _favoriteAlbums = favoriteAlbums.map((id) {
          return {
            'albumName':
                elementos.firstWhere((album) => album[0].toString() == id)[1],
            'image': 'assets/albumes/$id.jpg'
          };
        }).toList();
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', _username);
    await prefs.setStringList('playlists', _playlists);
    await prefs.setStringList(
      'favoriteAlbums',
      _favoriteAlbums.map((album) => album['albumName']!.toString()).toList(),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _toggleFavoriteAlbums() {
    setState(() {
      _showFavorites = !_showFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil'),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfile(
              size: size,
              image: _image,
              onPickImage: _pickImage,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Nombre de usuario'),
                    controller: TextEditingController(text: _username),
                    onSubmitted: (value) {
                      setState(() {
                        _username = value;
                      });
                      _saveProfileData();
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleFavoriteAlbums,
                    child: Text(_showFavorites
                        ? "Ocultar Álbumes Favoritos"
                        : "Ver Álbumes Favoritos"),
                  ),
                  if (_showFavorites) ...[
                    const SizedBox(height: 20),
                    _favoriteAlbums.isEmpty
                        ? const Text("No tienes álbumes favoritos.")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _favoriteAlbums.length,
                            itemBuilder: (context, index) {
                              final album = _favoriteAlbums[index];
                              return ListTile(
                                leading: Image.asset(
                                  album['image']!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(album['albumName']!),
                              );
                            },
                          ),
                  ],
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      //TODO Ir a la pantalla de playlists
                    },
                    child: const Text("Ver mis playlists"),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderProfile extends StatelessWidget {
  final Size size;
  final File? image;
  final VoidCallback onPickImage;

  const HeaderProfile({
    super.key,
    required this.size,
    required this.image,
    required this.onPickImage,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      color: const Color(0xff2d3e4f),
      child: Center(
        child: GestureDetector(
          onTap: onPickImage,
          child: CircleAvatar(
            radius: 100,
            backgroundImage: image != null ? FileImage(image!) : null,
            child: image == null
                ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
