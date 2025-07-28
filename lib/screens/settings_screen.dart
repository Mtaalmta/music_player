import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  String? _notificationSound;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5; // Default volume (50%)

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickNotificationSound() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      setState(() {
        _notificationSound = filePath;
      });
      // Save the selected sound path to preferences
      await _updatePreference('notificationSound', filePath);
    }
  }

  Future<void> _playNotificationSound() async {
    if (_notificationSound != null) {
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(DeviceFileSource(_notificationSound!));
    }
  }

  Future<void> _stopNotificationSound() async {
    await _audioPlayer.stop();
  }

  Future<void> _updatePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _updatePreference('notificationsEnabled', value);
            },
          ),
          if (_notificationsEnabled)
            ListTile(
              title: const Text('Notification Sound'),
              subtitle: Text(
                _notificationSound ?? 'Default',
                style: const TextStyle(color: Colors.grey),
              ),
              leading: const Icon(Icons.music_note),
              onTap: _pickNotificationSound,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: _playNotificationSound,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _stopNotificationSound,
                  ),
                ],
              ),
            ),
          if (_notificationsEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      _audioPlayer.setVolume(_volume);
                    },
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(_volume * 100).round()}%',
                  ),
                ],
              ),
            ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}