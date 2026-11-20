import "package:android_dev/screens/home_screen/models/comment_model.dart";

class PostModel {
  final int id;
  final int userId;
  final String username;
  final String avatarPath;
  final String imagePath;
  final String description;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatarPath,
    required this.imagePath,
    required this.description,
    required this.likeCount,
    required this.comments,
    this.isLiked = false,
    this.isSaved = false,
  });

  int get commentCount => comments.length;

  PostModel copyWith({
    int? likeCount,
    bool? isLiked,
    bool? isSaved,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id,
      userId: userId,
      username: username,
      avatarPath: avatarPath,
      imagePath: imagePath,
      description: description,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      comments: comments ?? this.comments,
    );
  }
}
