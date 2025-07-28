class AudioModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final String albumArtPath;
  final Duration duration;

  AudioModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.albumArtPath,
    required this.duration,
  });
}