import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:android_dev/screens/home_screen/widgets/stories_list.dart";
import "package:material_ui/material_ui.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HomeTab extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final stories = ref.watch(storiesProvider);

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
            child: StoriesList(stories: stories),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: PostWidget(post: posts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
