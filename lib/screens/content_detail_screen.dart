import 'package:material_ui/material_ui.dart';

class ContentDetailScreen extends StatelessWidget {
  final String imagePath;
  final String description;
  final String title;
  const ContentDetailScreen({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, style: const TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
