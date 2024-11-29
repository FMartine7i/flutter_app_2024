import 'package:flutter/material.dart';
import 'package:flutter_application_base/mocks/albumes_mock.dart'
    show elementos;
import 'album_individual.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumesListScreen extends StatefulWidget {
  const AlbumesListScreen({super.key});

  @override
  AlbumesListScreenState createState() => AlbumesListScreenState();
}

class AlbumesListScreenState extends State<AlbumesListScreen> {
  String _searchQuery = '';
  List<List<dynamic>> _filteredElements = elementos.cast<List<dynamic>>();

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredElements = elementos
          .where((album) =>
              album[1].toString().toLowerCase().contains(
                  query.toLowerCase()) || // Filtrar por nombre de álbum
              album[2].toString().toLowerCase().contains(
                  query.toLowerCase())) // Filtrar por nombre de la banda
          .toList()
          .cast<List<dynamic>>();
    });
  }

  void _toggleFavorite(int index) async {
    setState(() {
      final mainIndex = elementos.indexOf(_filteredElements[index]);
      elementos[mainIndex][5] = !elementos[mainIndex][5];
    });

    final prefs = await SharedPreferences.getInstance();

    final favoriteAlbums = elementos
        .where((album) => album[5]) // Solo los favoritos
        .map((album) => album[0].toString()) // Guardar el id del álbum
        .toList();
    await prefs.setStringList('favoriteAlbums', favoriteAlbums);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar álbum...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _updateSearchQuery,
        ),
        backgroundColor: const Color.fromARGB(255, 67, 37, 81),
      ),
      body: ListView.builder(
        itemCount: _filteredElements.length,
        itemBuilder: (context, index) {
          final album = _filteredElements[index];
          return GestureDetector(
            onTap: () async {
              //ir a la pantalla de visualizacion individual
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumDetailScreen(
                    index: index,
                    album: {
                      'id': album[0],
                      'albumName': album[1],
                      'bandName': album[2],
                      'song': album[3],
                      'year': album[4],
                      'isFavorite': album[5],
                    },
                  ),
                ),
              );

              setState(() {});
            },
            child: AlbumCard(
              index: index,
              id: album[0],
              albumName: album[1],
              bandName: album[2],
              song: album[3],
              year: album[4],
              isFavorite: album[5],
              onFavoriteToggle: () => _toggleFavorite(index),
            ),
          );
        },
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final int index;
  final String id;
  final String albumName;
  final String bandName;
  final String song;
  final int year;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const AlbumCard({
    super.key,
    required this.index,
    required this.id,
    required this.albumName,
    required this.bandName,
    required this.song,
    required this.year,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              'assets/albumes/$id.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/albumes/error.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    albumName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(bandName),
                  Text('Año: $year'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? const Color.fromARGB(255, 145, 92, 155)
                    : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}


