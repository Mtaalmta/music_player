import 'package:just_audio/just_audio.dart';
      import '../models/audio_model.dart';

      class AudioService {
        final AudioPlayer _audioPlayer = AudioPlayer();
        AudioModel? _currentTrack;

        AudioModel? get currentTrack => _currentTrack;
        bool get isPlaying => _audioPlayer.playing;

        AudioService() {
          _audioPlayer.playbackEventStream.listen(
            (event) {
              // Handle playback events (e.g., update UI or state)
            },
            onError: (error, stackTrace) {
              print('Audio playback error: $error');
            },
          );
        }

        Future<void> play(AudioModel track) async {
          try {
            if (_currentTrack != track) {
              _currentTrack = track;
              await _audioPlayer.setFilePath(track.filePath);
            }
            await _audioPlayer.play();
          } catch (e) {
            print('Error playing audio: $e');
          }
        }

        Future<void> pause() async {
          try {
            await _audioPlayer.pause();
          } catch (e) {
            print('Error pausing audio: $e');
          }
        }

        Future<void> stop() async {
          try {
            await _audioPlayer.stop();
            _currentTrack = null;
          } catch (e) {
            print('Error stopping audio: $e');
          }
        }

        void dispose() {
          _audioPlayer.dispose();
        }
      }