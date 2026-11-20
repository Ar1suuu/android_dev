import "package:android_dev/screens/auth/providers/auth_providers.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_ui/material_ui.dart";

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final posts = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Could not load profile"),
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
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(child: Text("Not signed in"));
          }

          final ownPosts = (posts.value ?? const <PostModel>[])
              .where((post) => post.userId == currentUser.id)
              .toList();
          final likes = ownPosts.fold<int>(
            0,
            (sum, post) => sum + post.likeCount,
          );
          final comments = ownPosts.fold<int>(
            0,
            (sum, post) => sum + post.commentCount,
          );

          return ListView(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: AssetImage(currentUser.avatarPath),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _Stat(
                                label: "Posts",
                                value: "${ownPosts.length}",
                              ),
                              _Stat(label: "Likes", value: "$likes"),
                              _Stat(
                                label: "Comments",
                                value: "$comments",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentUser.displayName.isEmpty
                          ? currentUser.username
                          : currentUser.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${currentUser.username}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (currentUser.bio.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(currentUser.bio),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        await ref.read(authServicesProvider).signOut();
                      },
                      child: const Text("Log out"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (ownPosts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text("No posts yet")),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(2),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                  itemCount: ownPosts.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      ownPosts[index].imagePath,
                      fit: BoxFit.cover,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
