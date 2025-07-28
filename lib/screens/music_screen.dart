import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<PlatformFile> _audioFiles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;
  double _volume = 0.5; // Default volume (50%)

  @override
  void initState() {
    super.initState();
    _loadSavedPlaylist(); // Load saved playlist on startup
  }

  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final filePaths = _audioFiles.map((file) => file.path).toList();
    await prefs.setString('savedPlaylist', jsonEncode(filePaths));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playlist saved!')),
    );
  }

  Future<void> _loadSavedPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPlaylist = prefs.getString('savedPlaylist');
    if (savedPlaylist != null) {
      final filePaths = List<String>.from(jsonDecode(savedPlaylist));
      setState(() {
        _audioFiles = filePaths
            .map((path) => PlatformFile(name: path.split('/').last, path: path, size: 524))
            .toList();
      });
    }
  }

  Future<void> _pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        dialogTitle: 'اختر ملف الصوت ',
        initialDirectory: selectedDirectory,
      );
      if (result != null) {
        setState(() {
          _audioFiles = result.files;
        });
      }
    }
  }

  Future<void> _playAudio(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(_volume); // Set the volume before playing
    await _audioPlayer.play(DeviceFileSource(_audioFiles[index].path!));
    setState(() {
      _playingIndex = index;
    });
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _playingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Folders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePlaylist, // Save playlist button
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _pickFolder,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_audioFiles.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _audioFiles.length,
                itemBuilder: (context, index) {
                  final file = _audioFiles[index];
                  final isPlaying = _playingIndex == index;
                  return ListTile(
                    leading: Icon(isPlaying ? Icons.music_note : Icons.audiotrack),
                    title: Text(file.name),
                    trailing: IconButton(
                      icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                      onPressed: () {
                        isPlaying ? _stopAudio() : _playAudio(index);
                      },
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Volume', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _volume,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                    _audioPlayer.setVolume(_volume); // Adjust volume in real-time
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_volume * 100).round()}%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}