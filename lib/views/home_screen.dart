import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/type/search_source_enum.dart';
import 'package:flutter_foodiefind/viewmodel/recipe_view_model.dart';
import 'package:flutter_foodiefind/views/recipe_detail_screen.dart';
import 'package:flutter_foodiefind/views/search_result_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/card.dart';
import 'package:flutter_foodiefind/widgets/recipe_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //Tunggu sampai screen built baru jalankan ini
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Panggil ViewModel yang sudah di inisialisasikan saat render
      final viewModel = Provider.of<RecipeViewModel>(context, listen: false);
      viewModel.fetchRandomRecipes();
      viewModel.fetchRecommendationRecipes();
    });
  }

  void _submitSearch() {
    final String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
            query: searchQuery,
            searchFrom: SearchSource.searchBar,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, // Start point of the gradient
                end: Alignment.bottomCenter, // End point of the gradient
                colors: [
                  Colors.green.withValues(alpha: 0.2), // Starting color
                  Colors.white.withValues(alpha: 0.1), // Ending color
                ],
                stops: [0.1, 0.3],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoldText(
                  text: 'Feeling Hungry?',
                  size: 20,
                  color: Colors.black54,
                ),
                const BoldText(
                  text: "What are we cooking today?",
                  size: 20,
                  color: Colors.black87,
                ),
                //DIVIDER
                SizedBox(height: 16),
                //Search Bar
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _searchController,
                    onFieldSubmitted: (value) => _submitSearch(),
                    decoration: InputDecoration(
                      hintText: 'Cari resep...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                //DIVIDER
                SizedBox(height: 16),
                const BoldText(
                  text: "Pilihan Acak Hari Ini",
                  size: 16,
                  color: Colors.green,
                ),
                // Random Pick Of the day section
                SizedBox(height: 8),
                Consumer<RecipeViewModel>(
                  builder: (context, viewModel, child) {
                    // Loading
                    if (viewModel.isFetchingRandom) {
                      return CardContainer(
                        height: 300,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    }

                    // Error
                    if (viewModel.isRandomRecipeErr) {
                      return CardContainer(
                        width: double.infinity,
                        height: 400,
                        containerPadd: const EdgeInsets.all(16),
                        containerDecoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Gagal memuat resep",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Success
                    if (viewModel.randomRecipes.isNotEmpty) {
                      // Ambil resep pertama dari list (randomRecipe cuman ada 1 saja)
                      final recipe = viewModel.randomRecipes.first;
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.network(
                                recipe.strMealThumb ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,

                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      // ketika loading tampilkan shimmer
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.white,
                                        ),
                                      );
                                    },

                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/failed_to_load_image.png',
                                    fit: BoxFit.cover,
                                    height: 300,
                                  );
                                },
                              ),
                              Positioned.fill(
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.0),
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                      stops: const [0.2, 0.9],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BoldText(
                                        text: recipe.strMeal,
                                        size: 18,
                                        color: Colors.white,
                                        textMaxline: 2,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        recipe.strCategory ?? "Tanpa Kategori",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Fallback jika data kosong tapi tidak error
                    return CardContainer(
                      child: const Center(
                        child: Text("Tidak ada resep ditemukan."),
                      ),
                    );
                  },
                ),

                //DIVIDER
                SizedBox(height: 16),
                //Rekomendasi Section
                const BoldText(
                  text: "Rekomendasi",
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(height: 8),
                Consumer<RecipeViewModel>(
                  builder: (context, viewModel, child) {
                    // Loading dengan shimmer
                    if (viewModel.isFetchingRecommendation) {
                      return GridView.builder(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    }

                    // Error
                    if (viewModel.isRecommendationErr) {
                      return Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: const Text("Gagal memuat rekomendasi."),
                      );
                    }

                    // Sukse
                    if (viewModel.recommendationRecipes.isNotEmpty) {
                      final recommendationRecipes =
                          viewModel.recommendationRecipes;
                      return GridView.builder(
                        itemCount: recommendationRecipes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                        itemBuilder: (context, index) {
                          final recipe = recommendationRecipes[index];

                          // Selector Hanya akan listening status favorit untuk satu card ini
                          return Selector<RecipeViewModel, bool>(
                            // selector: hanya ambil data bool (isFavorited) untuk resep ini
                            selector: (_, viewModel) => viewModel
                                .favoritedRecipes
                                .containsKey(recipe.idMeal),

                            // Rebuild jika selector isFavorited berubah
                            builder: (context, isFavorited, child) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailScreen(
                                        recipeId: recipe.idMeal,
                                      ),
                                    ),
                                  ),
                                },
                                child: RecipeCard(
                                  title: recipe.strMeal,
                                  subtitle:
                                      recipe.strCategory ??
                                      'Tidak ada kategori',
                                  imageNetworkUrl: recipe.strMealThumb ?? '',
                                  isFavorited: isFavorited,
                                  onFavoriteTap: () {
                                    // Akan trigger toggleFavoriteRecipe
                                    context
                                        .read<RecipeViewModel>()
                                        .toggleFavoriteRecipe(
                                          recipe.idMeal,
                                          recipe,
                                        );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    // Fallback jika data kosong
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: const Text(
                        "Tidak ada resep rekomendasi ditemukan.",
                      ),
                    );
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
