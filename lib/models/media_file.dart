enum MediaType { image, video }

class MediaFile {
  final String id;
  final String filePath;
  final String fileName;
  final MediaType type;
  final DateTime dateAdded;

  MediaFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.type,
    required this.dateAdded,
  });
}