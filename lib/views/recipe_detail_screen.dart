import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/viewmodel/recipe_view_model.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/box_card.dart';
import 'package:flutter_foodiefind/widgets/card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeViewModel = Provider.of<RecipeViewModel>(
        context,
        listen: false,
      );
      recipeViewModel.clearDetailRecipeData();
      recipeViewModel.fetchDetailRecipes(widget.recipeId);
    });
  }

  @override
  // Perbarui widget jika data recipeId yang diterima berubah
  void didUpdateWidget(covariant RecipeDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recipeId != oldWidget.recipeId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<RecipeViewModel>(
          context,
          listen: false,
        ).fetchDetailRecipes(widget.recipeId);
      });
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // Cek apakah user masih buka halaman nya (mount) selama jeda asinkronus
      if (!mounted) return;
      // Tampilkan snackbar jika gagal membuka URL// Tampilkan snackbar jika gagal membuka URL
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isFetchingDetailRecipe) {
          return Scaffold(
            appBar: AppBar(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: BackButton(color: Colors.black54),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error
        if (viewModel.isDetailsRecipeErr) {
          return Scaffold(
            appBar: AppBar(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: BackButton(color: Colors.black54),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Center(child: Text('Error Gagal Memuat Detail Resep')),
          );
        }

        // Data Empty
        if (viewModel.detailRecipe.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: BackButton(color: Colors.black54),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Center(child: Text('Recipe tidak ditemukan.')),
          );
        }

        //Berdasarkan API, selalu mengembalikan 1 data dalam bentuk array
        //Maka dari itu ambil 'first'
        final recipe = viewModel.detailRecipe.first;
        final ingredientsData = recipe.ingredientsWithMeasures;
        final ingredientsDataEntriesList = ingredientsData.entries.toList();

        // Sukses (default)
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.7),
                  child: BackButton(color: Colors.black54),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 350.0,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        // Gambar utama dari data resep
                        child: Image.network(
                          recipe.strMealThumb ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 60),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: CardContainer(
                          height: 150,
                          containerDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                offset: const Offset(0, 5),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Judul resep dari data
                                BoldText(
                                  text: recipe.strMeal,
                                  textAlignment: TextAlign.center,
                                  textMaxline: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                  size: 20,
                                ),
                                const SizedBox(height: 8),
                                // Kategori dan area dari data
                                Text(
                                  "${recipe.strCategory} • ${recipe.strArea}",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BoldText(text: 'Ingredients', size: 20),
                      const SizedBox(height: 8),
                      // Tampilkan daftar bahan-bahan secara horizontal
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ingredientsDataEntriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ingredient =
                                ingredientsDataEntriesList[index];
                            final normalizedIngredientName = (ingredient.key)
                                .replaceAll(' ', '-')
                                .toLowerCase();
                            final ingredientImageUrl =
                                'https://www.themealdb.com/images/ingredients/$normalizedIngredientName.png';

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: BoxCard(
                                imageUrl: ingredientImageUrl,
                                titleBelow: ingredient.key,
                                subtitleBelow: ingredient.value,
                                height: 100,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const BoldText(text: 'Instructions', size: 20),
                      const SizedBox(height: 8),
                      // Tampilkan instruksi dari data
                      Text(
                        recipe.strInstructions ?? 'No instructions available.',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                // Jarak untuk Floating Action Button
              ],
            ),
          ),
          // Tampilkan tombol Youtube jika ada link
          floatingActionButton:
              (recipe.strYoutube != null && recipe.strYoutube!.isNotEmpty)
              ? FloatingActionButton.extended(
                  onPressed: () => _launchURL(recipe.strYoutube!),
                  backgroundColor: Colors.green,
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text(
                    "Watch on Youtube",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              (recipe.strYoutube != null && recipe.strYoutube!.isNotEmpty)
              ? FloatingActionButtonLocation.centerFloat
              : null,
        );
      },
    );
  }
}
