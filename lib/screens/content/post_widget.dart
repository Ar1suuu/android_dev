import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/widgets/comment_widget.dart";
import "package:flutter/material.dart";

class PostWidget extends StatefulWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      widget.post.isLiked = _isLiked;
      widget.post.addLike(widget.post.likeCount + (_isLiked ? 1 : -1));
    });
  }

  void _openComments() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 380,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                "Comments (${widget.post.commentCount})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: widget.post.comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(comment: widget.post.comments[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage(post.avatarUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(post.imageUrl, fit: BoxFit.cover),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : null,
                ),
              ),
              IconButton(
                onPressed: _openComments,
                icon: const Icon(Icons.chat_bubble_outline),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "${post.likeCount} likes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Expanded(child: Text(post.description)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (post.comments.isNotEmpty)
            CommentWidget(comment: post.comments.first),
          if (post.comments.length > 1)
            TextButton(
              onPressed: _openComments,
              child: Text(
                "View all ${post.commentCount} comments",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
