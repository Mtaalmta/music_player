import 'package:flutter/foundation.dart';
import '../models/audio_model.dart';
import '../services/audio_service.dart';

class MusicProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  AudioModel? get currentTrack => _audioService.currentTrack;
  bool get isPlaying => _audioService.isPlaying;

  void play(AudioModel track) {
    _audioService.play(track);
    notifyListeners();
  }

  void pause() {
    _audioService.pause();
    notifyListeners();
  }

  void stop() {
    _audioService.stop();
    notifyListeners();
  }

  // Add more controls as needed (next, previous, etc.)
}