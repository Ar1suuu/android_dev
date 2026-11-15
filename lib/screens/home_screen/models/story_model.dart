class StoryModel {
  final String username;
  final String imagePath;
  final bool isSeen;

  const StoryModel({
    required this.username,
    required this.imagePath,
    this.isSeen = false,
  });
}
