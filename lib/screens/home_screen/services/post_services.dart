import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:android_dev/screens/home_screen/models/user_model.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class PostServices {
  final List<StoryModel> stories = [];

  SupabaseClient get _client => Supabase.instance.client;

  void batchAddStories(List<StoryModel> newStories) {
    stories.addAll(newStories);
  }

  Future<List<PostModel>> fetchPosts(int currentUserId) async {
    final results = await Future.wait([
      _client.from("users").select(
            "id, username, display_name, avatar_url, bio",
          ),
      _client.from("posts").select(
            "id, user_id, image_url, caption, location",
          ).order("id"),
      _client.from("comments").select("id, post_id, user_id, body").order("id"),
      _client.from("post_likes").select("post_id, user_id"),
      _client.from("comment_likes").select("comment_id, user_id"),
    ]);

    final users = <int, UserModel>{};
    for (final row in results[0]) {
      final id = _asInt(row["id"]);
      users[id] = UserModel(
        id: id,
        username: _asText(row["username"]),
        displayName: _asText(row["display_name"]),
        avatarPath: _asText(row["avatar_url"]),
        bio: _asText(row["bio"]),
      );
    }

    final postLikes = <int, Set<int>>{};
    for (final row in results[3]) {
      postLikes
          .putIfAbsent(_asInt(row["post_id"]), () => <int>{})
          .add(_asInt(row["user_id"]));
    }

    final commentLikes = <int, Set<int>>{};
    for (final row in results[4]) {
      commentLikes
          .putIfAbsent(_asInt(row["comment_id"]), () => <int>{})
          .add(_asInt(row["user_id"]));
    }

    final commentsByPost = <int, List<CommentModel>>{};
    for (final row in results[2]) {
      final commentId = _asInt(row["id"]);
      final author = users[_asInt(row["user_id"])];
      final likes = commentLikes[commentId] ?? <int>{};
      final comment = CommentModel(
        id: commentId,
        postId: _asInt(row["post_id"]),
        username: author?.username ?? "unknown",
        text: _asText(row["body"]),
        avatarPath: author?.avatarPath ?? "assets/images/post.jpg",
        likeCount: likes.length,
        isLiked: likes.contains(currentUserId),
      );
      commentsByPost.putIfAbsent(comment.postId, () => []).add(comment);
    }

    final posts = <PostModel>[];
    for (final row in results[1]) {
      final id = _asInt(row["id"]);
      final userId = _asInt(row["user_id"]);
      final author = users[userId];
      final likes = postLikes[id] ?? <int>{};
      final imagePath = _asText(row["image_url"]);

      posts.add(
        PostModel(
          id: id,
          userId: userId,
          username: author?.username ?? "unknown",
          avatarPath: author?.avatarPath ?? "assets/images/post.jpg",
          imagePath: imagePath.isEmpty
              ? "assets/images/post.jpg"
              : imagePath,
          description: _asText(row["caption"]),
          location: _asText(row["location"]),
          likeCount: likes.length,
          isLiked: likes.contains(currentUserId),
          comments: commentsByPost[id] ?? [],
        ),
      );
    }

    return posts;
  }

  Future<CommentModel> addComment({
    required int postId,
    required UserModel user,
    required String body,
  }) async {
    final row = await _client
        .from("comments")
        .insert({"post_id": postId, "user_id": user.id, "body": body})
        .select("id, post_id")
        .single();

    return CommentModel(
      id: _asInt(row["id"]),
      postId: _asInt(row["post_id"]),
      username: user.username,
      text: body,
      avatarPath: user.avatarPath,
    );
  }

  Future<void> togglePostLike({
    required int postId,
    required int userId,
    required bool wasLiked,
  }) async {
    final table = _client.from("post_likes");
    if (wasLiked) {
      await table.delete().eq("post_id", postId).eq("user_id", userId);
    } else {
      await table.insert({"post_id": postId, "user_id": userId});
    }
  }

  Future<void> toggleCommentLike({
    required int commentId,
    required int userId,
    required bool wasLiked,
  }) async {
    final table = _client.from("comment_likes");
    if (wasLiked) {
      await table.delete().eq("comment_id", commentId).eq("user_id", userId);
    } else {
      await table.insert({"comment_id": commentId, "user_id": userId});
    }
  }

  int _asInt(dynamic value) => (value as num).toInt();

  String _asText(dynamic value) => value as String? ?? "";
}
