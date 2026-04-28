import 'package:flutter/material.dart';

class PickThumbnail extends StatelessWidget {
  final String? imagePath;
  const PickThumbnail({super.key, required this.imagePath});

  void _openImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(child: Image.asset(imagePath)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    return GestureDetector(
      onTap: path != null ? () => _openImage(context, path) : null,
      child: Container(
        width: 110,
        height: 75,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
          image: path != null
              ? DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: path == null ? _Placeholder() : null,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          color: Colors.grey.shade400,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          'No Image',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    );
  }
}
