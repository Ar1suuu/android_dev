import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:android_dev/screens/home_screen/widgets/stories_list.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_ui/material_ui.dart";

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

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
            child: posts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Could not load posts"),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(currentUserProvider);
                        ref.invalidate(postsProvider);
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
              data: (items) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: PostWidget(post: items[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
