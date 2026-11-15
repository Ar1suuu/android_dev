import "package:android_dev/screens/home_screen/models/comment_model.dart";

class PostModel {
  final int id;
  final String username;
  final String avatarUrl;
  final String imageUrl;
  final String description;
  final int likeCount;
  final bool isLiked;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.imageUrl,
    required this.description,
    required this.likeCount,
    required this.comments,
    this.isLiked = false,
  });

  int get commentCount => comments.length;

  PostModel copyWith({int? likeCount, bool? isLiked}) {
    return PostModel(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      imageUrl: imageUrl,
      description: description,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments,
    );
  }
}
