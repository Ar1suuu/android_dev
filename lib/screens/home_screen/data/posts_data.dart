import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";

const String sampleImageUrl =
    "https://www.thedesignwork.com/wp-content/uploads/2011/10/Random-Pictures-of-Conceptual-and-Creative-Ideas-01.jpg";

final List<PostModel> postsData = [
  PostModel(
    username: "aminloh",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "morning coffee hits different fr",
    likeCount: 1248,
    comments: [
      CommentModel(
        username: "rizzler",
        text: "bro same every day",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "goofy_ahh",
        text: "this cup is lowkey fire",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "gugaluga",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "this fit is lowkey bussin no cap",
    likeCount: 892,
    comments: [
      CommentModel(
        username: "mewing_master",
        text: "fit goes crazy",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "grimace_shake",
        text: "where u got that",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "jojo",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "bro the vibes today are immaculate",
    likeCount: 2140,
    comments: [
      CommentModel(
        username: "broccoli_head",
        text: "vibes are unmatched",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "skibidi_king",
        text: "we outside fr",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "skibidi_king",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "no cap this spot is kinda fire",
    likeCount: 1576,
    comments: [
      CommentModel(
        username: "aminloh",
        text: "drop the location",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "jojo",
        text: "taking notes rn",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "sigma_lord",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "grinding today so tomorrow we chill",
    likeCount: 734,
    comments: [
      CommentModel(
        username: "no_cap_nina",
        text: "respect the hustle",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "bussin_bro",
        text: "me after one coffee",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "gyattzilla",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "my camera roll is 90% random pics",
    likeCount: 1980,
    comments: [
      CommentModel(
        username: "gugaluga",
        text: "realest thing i seen today",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "fanum_tax",
        text: "send the other 10%",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "ohio_rizz",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "caught the sunset before it dipped",
    likeCount: 1123,
    comments: [
      CommentModel(
        username: "gyattzilla",
        text: "this is so tuff",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "rizzler",
        text: "nature said lemme cook",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "fanum_tax",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "living rent free in my head",
    likeCount: 2665,
    comments: [
      CommentModel(
        username: "sigma_lord",
        text: "who let bro cook",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "bussin_bro",
        text: "bro is down bad",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "bussin_bro",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "bro said one more minute and left me on read",
    likeCount: 641,
    comments: [
      CommentModel(
        username: "ohio_rizz",
        text: "that is foul",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "broccoli_head",
        text: "not the read receipt",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
  PostModel(
    username: "no_cap_nina",
    avatarUrl: sampleImageUrl,
    imageUrl: sampleImageUrl,
    description: "whole day was mid until this happened",
    likeCount: 1327,
    comments: [
      CommentModel(
        username: "fanum_tax",
        text: "the plot twist",
        avatarUrl: sampleImageUrl,
      ),
      CommentModel(
        username: "skibidi_king",
        text: "main character energy",
        avatarUrl: sampleImageUrl,
      ),
    ],
  ),
];

const List<StoryModel> storiesData = [
  StoryModel(username: "aminloh", imageUrl: sampleImageUrl),
  StoryModel(username: "gugaluga", imageUrl: sampleImageUrl),
  StoryModel(username: "jojo", imageUrl: sampleImageUrl, isSeen: true),
  StoryModel(username: "skibidi_king", imageUrl: sampleImageUrl),
  StoryModel(username: "sigma_lord", imageUrl: sampleImageUrl, isSeen: true),
  StoryModel(username: "gyattzilla", imageUrl: sampleImageUrl),
  StoryModel(username: "ohio_rizz", imageUrl: sampleImageUrl),
  StoryModel(username: "fanum_tax", imageUrl: sampleImageUrl, isSeen: true),
  StoryModel(username: "bussin_bro", imageUrl: sampleImageUrl),
  StoryModel(username: "no_cap_nina", imageUrl: sampleImageUrl),
];
