import "package:android_dev/screens/home_screen/models/comment_model.dart";

class PostModel {
  final String username;
  final String avatarUrl;
  final String imageUrl;
  final String description;
  int likeCount;
  bool isLiked;
  final List<CommentModel> comments;

  PostModel({
    required this.username,
    required this.avatarUrl,
    required this.imageUrl,
    required this.description,
    required this.likeCount,
    required this.comments,
    this.isLiked = false,
  });

  int get commentCount => comments.length;

  void addLike(int newCount) {
    likeCount = newCount;
  }

  void addComment(CommentModel comment) {
    comments.add(comment);
  }
}
