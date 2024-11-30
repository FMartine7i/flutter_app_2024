import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_base/mocks/albumes_mock.dart'
    show elementos;
import 'package:flutter_application_base/mocks/usuario_mock.dart' show usuario;
import 'package:flutter_application_base/mocks/songs_mock.dart' show elements;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String _username = "Usuario";
  List<Map<String, dynamic>> _likedSongs = [];
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
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _image = File(imagePath);
      }
      _username = prefs.getString('username') ?? usuario[0];

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

      _likedSongs = elements
          .where((song) => song[4] == true)
          .map((song) => {
                'songName': song[1],
                'artist': song[2],
                'album': song[3],
              })
          .toList();
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    await prefs.setStringList(
      'favoriteAlbums',
      _favoriteAlbums.map((album) => album['albumName']!.toString()).toList(),
    );
    await prefs.setStringList(
      'likedSongs',
      _likedSongs.map((song) => song['songName']!.toString()).toList(),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imagePath = pickedFile.path; 

      setState(() {
        _image = File(imagePath);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', imagePath);
    }
  }

  //TODO: agregar los avatar
  void _pickAvatar() {
    setState(() {
      _image = null;
    });
  }

  void _toggleFavoriteAlbums() {
    setState(() {
      _showFavorites = !_showFavorites;
    });
  }

  void _changeUsername() {
    showDialog(
      context: context,
      builder: (context) {
        String newUsername = _username;
        return AlertDialog(
          title: const Text("Cambiar nombre de usuario"),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: const InputDecoration(
              labelText: "Nuevo nombre de usuario",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = newUsername;
                });
                _saveProfileData();
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
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
              onPickAvatar: _pickAvatar,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Usuario: $_username",
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          shadows: [
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(255, 129, 72, 155),
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _changeUsername,
                      ),
                    ],
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
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Playlist personalizada",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 1.0,
                                  color: Color.fromARGB(255, 158, 46, 177),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: _likedSongs.isEmpty
                                    ? const Center(
                                        child: Text("No hay canciones"),
                                      )
                                    : ListView.builder(
                                        itemCount: _likedSongs.length,
                                        itemBuilder: (context, index) {
                                          final song = _likedSongs[index];
                                          return ListTile(
                                            title: Text(song['songName']!),
                                            subtitle: Text(
                                                "${song['artist']} - ${song['album']}"),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      );
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
  final VoidCallback onPickAvatar;

  const HeaderProfile({
    super.key,
    required this.size,
    required this.image,
    required this.onPickImage,
    required this.onPickAvatar,
  });

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Seleccionar avatar"),
              onTap: () {
                Navigator.of(context).pop();
                onPickAvatar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Elegir foto de la galería"),
              onTap: () {
                Navigator.of(context).pop();
                onPickImage();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.30,
      child: Center(
        child: GestureDetector(
          onTap: () => _showImageOptions(context),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 111, 38, 151),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: image != null ? FileImage(image!) : null,
              backgroundColor: Colors.transparent,
              child: image == null
                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
