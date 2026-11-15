import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";

class PostServices {
  final List<PostModel> posts = [];
  final List<StoryModel> stories = [];

  void batchAddPosts(List<PostModel> newPosts) {
    posts.addAll(newPosts);
  }

  void batchAddStories(List<StoryModel> newStories) {
    stories.addAll(newStories);
  }
}
