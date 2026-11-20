import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("post copyWith updates likes and saves", () {
    final post = PostModel(
      id: 1,
      userId: 1,
      username: "aminloh",
      avatarPath: "assets/images/post.jpg",
      imagePath: "assets/images/post.jpg",
      description: "morning coffee hits different fr",
      likeCount: 4,
      comments: [],
    );

    final liked = post.copyWith(isLiked: true, likeCount: 5, isSaved: true);

    expect(liked.isLiked, isTrue);
    expect(liked.likeCount, 5);
    expect(liked.isSaved, isTrue);
    expect(post.isLiked, isFalse);
    expect(post.likeCount, 4);
  });

  test("comment copyWith updates likes", () {
    const comment = CommentModel(
      id: 1,
      postId: 1,
      username: "rizzlerr",
      text: "bro same every day",
      avatarPath: "assets/images/post.jpg",
      likeCount: 2,
    );

    final liked = comment.copyWith(isLiked: true, likeCount: 3);

    expect(liked.isLiked, isTrue);
    expect(liked.likeCount, 3);
    expect(comment.isLiked, isFalse);
    expect(comment.likeCount, 2);
  });
}
