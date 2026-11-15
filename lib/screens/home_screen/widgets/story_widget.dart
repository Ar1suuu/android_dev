import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:material_ui/material_ui.dart";

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: story.isSeen ? Colors.grey.shade300 : Colors.pink,
                width: 2.5,
              ),
            ),
            child: CircleAvatar(
              radius: 31,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(story.imageUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
