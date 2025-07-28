import 'package:flutter/material.dart';

class MusicFoldersScreen extends StatelessWidget {
  const MusicFoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Folders')),
      body: const Center(child: Text('Music Folders Screen')),
    );
  }
}