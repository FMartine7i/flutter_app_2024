import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image(image: AssetImage('assets/images/moodify_1.png'))),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80
      ),
      drawer: DrawerMenu(),
      //body: const Center(child: Image(image: AssetImage('assets/images/mood_bg.png'))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () {
          log('click button');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
