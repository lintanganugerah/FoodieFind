import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<int> _listItems = List.generate(6, (int index) => 1 + index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BoldText(text: "Favorite Recipes", size: 16),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: _listItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final item = _listItems[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://placehold.co/1920x1080/png',
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: double.infinity,
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
                  BoldText(text: "Title $item", size: 16, color: Colors.green),
                  const Text("Subtitle"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
