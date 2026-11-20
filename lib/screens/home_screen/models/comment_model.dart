class CommentModel {
  final int id;
  final int postId;
  final String username;
  final String text;
  final String avatarPath;
  final int likeCount;
  final bool isLiked;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.username,
    required this.text,
    required this.avatarPath,
    this.likeCount = 0,
    this.isLiked = false,
  });

  CommentModel copyWith({
    int? likeCount,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id,
      postId: postId,
      username: username,
      text: text,
      avatarPath: avatarPath,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
