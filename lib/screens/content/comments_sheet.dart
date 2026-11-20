import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:android_dev/screens/home_screen/widgets/comment_widget.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_ui/material_ui.dart";

class CommentsSheet extends ConsumerStatefulWidget {
  final int postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    try {
      await ref.read(postsProvider.notifier).addComment(widget.postId, text);
      if (!mounted) return;
      _controller.clear();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not add comment")),
      );
    }
  }

  PostModel? _findPost(List<PostModel> posts) {
    for (final post in posts) {
      if (post.id == widget.postId) return post;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 420,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              "Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: posts.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const Center(
                  child: Text("Could not load comments"),
                ),
                data: (items) {
                  final post = _findPost(items);
                  if (post == null || post.comments.isEmpty) {
                    return const Center(child: Text("No comments yet"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      return CommentWidget(
                        postId: post.id,
                        comment: post.comments[index],
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        hintText: "Add a comment",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
