import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:material_ui/material_ui.dart";

class CommentWidget extends StatefulWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: AssetImage(comment.avatarPath),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Expanded(child: Text(comment.text)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            visualDensity: VisualDensity.compact,
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: _isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
