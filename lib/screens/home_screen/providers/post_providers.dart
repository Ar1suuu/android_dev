import "package:android_dev/screens/auth/providers/auth_providers.dart";
import "package:android_dev/screens/home_screen/data/posts_data.dart";
import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final postServicesProvider = Provider<PostServices>((ref) {
  final postServices = PostServices();
  postServices.batchAddStories(storiesData);
  return postServices;
});

final storiesProvider = Provider<List<StoryModel>>((ref) {
  return ref.watch(postServicesProvider).stories;
});

class PostsNotifier extends AsyncNotifier<List<PostModel>> {
  @override
  Future<List<PostModel>> build() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user == null) return [];
    return ref.watch(postServicesProvider).fetchPosts(user.id);
  }

  Future<void> toggleLike(int postId) async {
    final posts = state.value;
    if (posts == null) return;

    final post = _findPost(posts, postId);
    if (post == null) return;

    final user = await ref.read(currentUserProvider.future);
    if (!ref.mounted || user == null) return;

    try {
      await ref.read(postServicesProvider).togglePostLike(
            postId: postId,
            userId: user.id,
            wasLiked: post.isLiked,
          );
    } catch (_) {
      return;
    }

    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;

    state = AsyncData([
      for (final item in current)
        if (item.id == postId)
          item.copyWith(
            isLiked: !item.isLiked,
            likeCount: item.likeCount + (item.isLiked ? -1 : 1),
          )
        else
          item,
    ]);
  }

  void toggleSave(int postId) {
    final posts = state.value;
    if (posts == null) return;

    state = AsyncData([
      for (final post in posts)
        if (post.id == postId)
          post.copyWith(isSaved: !post.isSaved)
        else
          post,
    ]);
  }

  Future<void> addComment(int postId, String text) async {
    final body = text.trim();
    if (body.isEmpty) return;

    final user = await ref.read(currentUserProvider.future);
    if (!ref.mounted || user == null) return;

    final comment = await ref.read(postServicesProvider).addComment(
          postId: postId,
          user: user,
          body: body,
        );

    if (!ref.mounted) return;
    final posts = state.value;
    if (posts == null) return;

    state = AsyncData([
      for (final post in posts)
        if (post.id == postId)
          post.copyWith(comments: [...post.comments, comment])
        else
          post,
    ]);
  }

  Future<void> toggleCommentLike(int postId, int commentId) async {
    final posts = state.value;
    if (posts == null) return;

    final comment = _findComment(posts, postId, commentId);
    if (comment == null) return;

    final user = await ref.read(currentUserProvider.future);
    if (!ref.mounted || user == null) return;

    try {
      await ref.read(postServicesProvider).toggleCommentLike(
            commentId: commentId,
            userId: user.id,
            wasLiked: comment.isLiked,
          );
    } catch (_) {
      return;
    }

    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;

    state = AsyncData([
      for (final post in current)
        if (post.id == postId)
          post.copyWith(
            comments: [
              for (final item in post.comments)
                if (item.id == commentId)
                  item.copyWith(
                    isLiked: !item.isLiked,
                    likeCount: item.likeCount + (item.isLiked ? -1 : 1),
                  )
                else
                  item,
            ],
          )
        else
          post,
    ]);
  }

  PostModel? _findPost(List<PostModel> posts, int postId) {
    for (final post in posts) {
      if (post.id == postId) return post;
    }
    return null;
  }

  CommentModel? _findComment(
    List<PostModel> posts,
    int postId,
    int commentId,
  ) {
    final post = _findPost(posts, postId);
    if (post == null) return null;

    for (final comment in post.comments) {
      if (comment.id == commentId) return comment;
    }
    return null;
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);
