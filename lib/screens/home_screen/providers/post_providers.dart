import "package:android_dev/screens/home_screen/data/posts_data.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final postServicesProvider = Provider<PostServices>((ref) {
  final postServices = PostServices();
  postServices.batchAddPosts(postsData);
  postServices.batchAddStories(storiesData);
  return postServices;
});

final storiesProvider = Provider<List<StoryModel>>((ref) {
  return ref.watch(postServicesProvider).stories;
});

class PostsNotifier extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() {
    return List.of(ref.watch(postServicesProvider).posts);
  }

  void toggleLike(int id) {
    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.likeCount + (post.isLiked ? -1 : 1),
          )
        else
          post,
    ];
  }

  void toggleSave(int id) {
    state = [
      for (final post in state)
        if (post.id == id) post.copyWith(isSaved: !post.isSaved) else post,
    ];
  }
}

final postsProvider = NotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);
