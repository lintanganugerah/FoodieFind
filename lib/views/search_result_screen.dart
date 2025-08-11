import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/type/search_source_enum.dart';
import 'package:flutter_foodiefind/viewmodel/recipe_view_model.dart';
import 'package:flutter_foodiefind/views/recipe_detail_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final SearchSource searchFrom;

  const SearchResultScreen({
    super.key,
    required this.query,
    required this.searchFrom,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeViewModel = Provider.of<RecipeViewModel>(
        context,
        listen: false,
      );
      recipeViewModel.clearSearchResults();
      recipeViewModel.searchRecipe(widget.query, widget.searchFrom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BoldText(text: "Result", size: 16),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText(text: "You Searched for:", size: 16),
                      SizedBox(width: 8),
                      Text(widget.query),
                    ],
                  ),
                ),
                Consumer<RecipeViewModel>(
                  builder: (context, recipeViewModel, child) {
                    final result = recipeViewModel.searchResultRecipes;
                    if (recipeViewModel.isSearching) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (recipeViewModel.isSerchingErr) {
                      return Center(
                        child: Text('Error Gagal Memuat Detail Resep'),
                      );
                    }

                    // Sukses
                    if (result.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.70,
                            ),
                        itemBuilder: (context, index) {
                          final item = result[index];
                          return Selector<RecipeViewModel, bool>(
                            // selector: hanya ambil data bool (isFavorited) untuk resep ini
                            selector: (_, viewModel) => viewModel
                                .favoritedRecipes
                                .containsKey(item.idMeal),

                            // Rebuild jika selector isFavorited berubah
                            builder: (context, isFavorited, child) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailScreen(
                                        recipeId: item.idMeal,
                                      ),
                                    ),
                                  ),
                                },
                                child: RecipeCard(
                                  title: item.strMeal,
                                  subtitle: item.strCategory ?? widget.query,
                                  imageNetworkUrl: item.strMealThumb ?? '',
                                  isFavorited: isFavorited,
                                  onFavoriteTap: () {
                                    // Akan trigger toggleFavoriteRecipe
                                    context
                                        .read<RecipeViewModel>()
                                        .toggleFavoriteRecipe(
                                          item.idMeal,
                                          item,
                                        );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return Center(child: Text("Tidak ada data"));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
