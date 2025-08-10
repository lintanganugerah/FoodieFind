import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:shimmer/shimmer.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageNetworkUrl;

  const RecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageNetworkUrl,
  });

  @override
  Widget build(BuildContext context) {
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
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          // Jika loading selesai, tampilkan gambar aslinya.
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        );
                      },
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        );
                      },
                ),
              ),
              Positioned(
                top: 1,
                child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.green),
                  onPressed: () {
                    // TODO: Ubah ini menjadi fungsionalitas hapus/favoritkan recipe
                  },
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
