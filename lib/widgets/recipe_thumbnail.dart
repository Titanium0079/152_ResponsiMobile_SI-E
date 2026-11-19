import 'package:flutter/material.dart';

class RecipeThumbnail extends StatelessWidget {
  final String imageUrl;
  final double size;

  const RecipeThumbnail({super.key, required this.imageUrl, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size,
        height: size,
        color: Colors.indigo.shade50,
        child: imageUrl.isEmpty
            ? const Icon(Icons.broken_image_outlined, color: Colors.indigo)
            : Image.network(
                imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.indigo.shade400,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No Img',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.indigo.shade400,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
