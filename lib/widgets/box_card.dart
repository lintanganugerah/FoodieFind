import 'package:flutter/material.dart';

class BoxCard extends StatelessWidget {
  final String? imageUrl;
  final String? imageAssets;
  final String? titleOverlay;
  final String? titleBelow;
  final String? subtitleBelow;

  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const BoxCard({
    super.key,
    this.imageAssets,
    this.imageUrl,
    this.titleOverlay,
    this.titleBelow,
    this.subtitleBelow,
    this.width,
    this.height,
    this.onTap,
  }) : assert(
         (imageUrl != null && imageAssets == null) ||
             (imageUrl == null && imageAssets != null),
         'Harus ada salah satu antara imageUrl atau imageAssets. Tidak bisa memberikan kedua nya.',
       );

  @override
  Widget build(BuildContext context) {
    // Jika width ada, gunakan width. Jika tidak, pakai height. Jika keduanya null, gunakan default 120.
    // Default rasio 1:1
    final double finalWidth = width ?? height ?? 120.0;
    final double finalHeight = height ?? width ?? 120.0;
    final image = imageAssets != null
        ? Image.asset(imageAssets!, fit: BoxFit.cover, width: 150)
        : Image.network(imageUrl!, fit: BoxFit.cover, width: 150);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: finalWidth, // Gunakan lebar final
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              // Ambil value jika width & height ada, Default 1:1
              aspectRatio: (width != null && height != null)
                  ? finalWidth / finalHeight
                  : 1.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: image,
                  ),
                  if (titleOverlay != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                  if (titleOverlay != null)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        titleOverlay!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bagian teks di bawah gambar jika ada
            if (titleBelow != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  titleBelow!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (subtitleBelow != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  subtitleBelow!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
