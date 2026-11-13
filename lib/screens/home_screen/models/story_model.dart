class StoryModel {
  final String username;
  final String imageUrl;
  final bool isSeen;

  const StoryModel({
    required this.username,
    required this.imageUrl,
    this.isSeen = false,
  });
}
