import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:shimmer/shimmer.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageNetworkUrl;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;
  final double? imageHeight;

  const RecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageNetworkUrl,
    this.isFavorited = false,
    this.onFavoriteTap,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final IconData heartIcon = isFavorited
        ? Icons.favorite
        : Icons.favorite_border;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageNetworkUrl,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        // Jika loading selesai, tampilkan gambar aslinya.
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                            height: imageHeight,
                          ),
                        );
                      },
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Image.asset(
                          'assets/images/failed_to_load_image.png',
                          fit: BoxFit.cover,
                          height: imageHeight,
                        );
                      },
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50.0),
                      onTap: onFavoriteTap,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(heartIcon, size: 20, color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        BoldText(
          text: title,
          size: 16,
          color: Colors.green,
          textMaxline: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
