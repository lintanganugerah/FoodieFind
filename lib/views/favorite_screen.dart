import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/viewmodel/recipe_view_model.dart';
import 'package:flutter_foodiefind/views/recipe_detail_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
        child: Container(
          padding: EdgeInsets.all(16),
          child: Consumer<RecipeViewModel>(
            builder: (context, viewModel, child) {
              final favoritedRecipes = context
                  .read<RecipeViewModel>()
                  .favoritedRecipes;
              if (viewModel.favoritedRecipes.isNotEmpty) {
                final favoritedList = favoritedRecipes.values.toList();
                return GridView.builder(
                  itemCount: favoritedRecipes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final recipe = favoritedList[index];

                    // Selector Hanya akan listening status favorit untuk satu card ini
                    return Selector<RecipeViewModel, bool>(
                      // selector: hanya ambil data bool (isFavorited) untuk resep ini
                      selector: (_, viewModel) =>
                          viewModel.favoritedRecipes.containsKey(recipe.idMeal),

                      // Rebuild jika selector isFavorited berubah
                      builder: (context, isFavorited, child) {
                        return GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipeId: recipe.idMeal),
                              ),
                            ),
                          },
                          child: RecipeCard(
                            title: recipe.strMeal,
                            subtitle:
                                recipe.strCategory ?? 'Tidak ada kategori',
                            imageNetworkUrl: recipe.strMealThumb ?? '',
                            isFavorited: isFavorited,
                            onFavoriteTap: () {
                              // Akan trigger toggleFavoriteRecipe
                              context
                                  .read<RecipeViewModel>()
                                  .toggleFavoriteRecipe(recipe.idMeal, recipe);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return Center(
                child: BoldText(
                  text:
                      "Tidak ada resep favorit ditemukan. Klik Icon hati pada resep untuk anda favoritkan, resep tersebut akan tersimpan disini",
                  textAlignment: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
