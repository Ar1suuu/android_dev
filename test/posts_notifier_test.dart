import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("toggleLike updates the post", () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final post = container.read(postsProvider).first;

    container.read(postsProvider.notifier).toggleLike(post.id);
    final likedPost = container.read(postsProvider).first;

    expect(likedPost.isLiked, isTrue);
    expect(likedPost.likeCount, post.likeCount + 1);

    container.read(postsProvider.notifier).toggleLike(post.id);
    final unlikedPost = container.read(postsProvider).first;

    expect(unlikedPost.isLiked, isFalse);
    expect(unlikedPost.likeCount, post.likeCount);
  });
}
