import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";

const String sampleImagePath = "assets/images/post.jpg";

final List<PostModel> postsData = [
  PostModel(
    id: 1,
    username: "aminloh",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "morning coffee hits different fr",
    likeCount: 1248,
    comments: [
      CommentModel(
        username: "rizzlerr",
        text: "bro same every day",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "goofy_ah",
        text: "this cup is lowkey fire",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 2,
    username: "gugalugaa",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "this fit is lowkey bussin no cap",
    likeCount: 892,
    comments: [
      CommentModel(
        username: "mewing_mastr",
        text: "fit goes crazy",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "grimace_shak",
        text: "where u got that",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 3,
    username: "jojoo",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "bro the vibes today are immaculate",
    likeCount: 2140,
    comments: [
      CommentModel(
        username: "brocoli_head",
        text: "vibes are unmatched",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "skibidi_kingg",
        text: "we outside fr",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 4,
    username: "skibidi_kingg",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "no cap this spot is kinda fire",
    likeCount: 1576,
    comments: [
      CommentModel(
        username: "aminloh",
        text: "drop the location",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "jojoo",
        text: "taking notes rn",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 5,
    username: "sigma_lordd",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "grinding today so tomorrow we chill",
    likeCount: 734,
    comments: [
      CommentModel(
        username: "no_cap_ninaa",
        text: "respect the hustle",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "bussin_broo",
        text: "me after one coffee",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 6,
    username: "gyattzila",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "my camera roll is 90% random pics",
    likeCount: 1980,
    comments: [
      CommentModel(
        username: "gugalugaa",
        text: "realest thing i seen today",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "fanum_taxx",
        text: "send the other 10%",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 7,
    username: "ohio_riz",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "caught the sunset before it dipped",
    likeCount: 1123,
    comments: [
      CommentModel(
        username: "gyattzila",
        text: "this is so tuff",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "rizzlerr",
        text: "nature said lemme cook",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 8,
    username: "fanum_taxx",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "living rent free in my head",
    likeCount: 2665,
    comments: [
      CommentModel(
        username: "sigma_lordd",
        text: "who let bro cook",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "bussin_broo",
        text: "bro is down bad",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 9,
    username: "bussin_broo",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "bro said one more minute and left me on read",
    likeCount: 641,
    comments: [
      CommentModel(
        username: "ohio_riz",
        text: "that is foul",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "brocoli_head",
        text: "not the read receipt",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
  PostModel(
    id: 10,
    username: "no_cap_ninaa",
    avatarPath: sampleImagePath,
    imagePath: sampleImagePath,
    description: "whole day was mid until this happened",
    likeCount: 1327,
    comments: [
      CommentModel(
        username: "fanum_taxx",
        text: "the plot twist",
        avatarPath: sampleImagePath,
      ),
      CommentModel(
        username: "skibidi_kingg",
        text: "main character energy",
        avatarPath: sampleImagePath,
      ),
    ],
  ),
];

const List<StoryModel> storiesData = [
  StoryModel(username: "aminloh", imagePath: sampleImagePath),
  StoryModel(username: "gugalugaa", imagePath: sampleImagePath),
  StoryModel(username: "jojoo", imagePath: sampleImagePath, isSeen: true),
  StoryModel(username: "skibidi_kingg", imagePath: sampleImagePath),
  StoryModel(username: "sigma_lordd", imagePath: sampleImagePath, isSeen: true),
  StoryModel(username: "gyattzila", imagePath: sampleImagePath),
  StoryModel(username: "ohio_riz", imagePath: sampleImagePath),
  StoryModel(username: "fanum_taxx", imagePath: sampleImagePath, isSeen: true),
  StoryModel(username: "bussin_broo", imagePath: sampleImagePath),
  StoryModel(username: "no_cap_ninaa", imagePath: sampleImagePath),
];
