import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/data/posts_data.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:android_dev/screens/home_screen/widgets/stories_list.dart";
import "package:flutter/material.dart";

class HomeTab extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PostServices _postServices = PostServices();

  @override
  void initState() {
    super.initState();
    _postServices.batchAddPosts(postsData);
    _postServices.batchAddStories(storiesData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Instagram"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: StoriesList(stories: _postServices.stories),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _postServices.posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: PostWidget(post: _postServices.posts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
