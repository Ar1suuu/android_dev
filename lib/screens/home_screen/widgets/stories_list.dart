import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:android_dev/screens/home_screen/widgets/story_widget.dart";
import "package:flutter/material.dart";

class StoriesList extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesList({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: stories.length,
        itemBuilder: (context, index) => StoryWidget(story: stories[index]),
      ),
    );
  }
}
