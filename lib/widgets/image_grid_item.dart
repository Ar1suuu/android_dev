import "package:android_dev/screens/content_detail_screen.dart";
import "package:material_ui/material_ui.dart";

class ImageGridItem extends StatelessWidget {
  final String imagePath;
  final String description;
  final String title;
  const ImageGridItem({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailScreen(
              imagePath: imagePath,
              description: description,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
