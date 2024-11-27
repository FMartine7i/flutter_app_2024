import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos pasados
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Accede a cada argumento con su clave
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('songs'),
        titleTextStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.bold),
        elevation: 10,
        backgroundColor: const Color.fromARGB(208, 159, 29, 206),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfileCustomItem(
              size: size,
              songCover: args['songCover'],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: BodyProfileCustomItem(args: args),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyProfileCustomItem extends StatelessWidget {
  final bool darkMode = false;
  final Map<String, dynamic> args;

  const BodyProfileCustomItem({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          args['song'],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          args['artist'],
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          args['album'], 
          style: const TextStyle(fontSize: 18)
        )
      ],
    );
  }

  InputDecoration decorationInput(
      {IconData? icon, String? hintText, String? helperText, String? label}) {
    return InputDecoration(
      fillColor: Colors.black,
      label: Text(label ?? ''),
      hintText: hintText,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 16),
      prefixIcon: (icon != null) ? Icon(icon) : null,
    );
  }
}

class HeaderProfileCustomItem extends StatelessWidget {
  final Size size;
  final String? songCover;

  const HeaderProfileCustomItem({
    super.key,
    this.songCover,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      margin: const EdgeInsets.all(20),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: songCover != ""
              ? Image.asset('assets/songs/$songCover.jpg', fit: BoxFit.cover)
              : Image.asset('assets/images/album.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
