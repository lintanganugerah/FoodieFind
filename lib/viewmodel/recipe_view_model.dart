// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_foodiefind/models/recipe_model.dart';
import 'package:flutter_foodiefind/models/services/recipe_api_services.dart';
import 'package:flutter_foodiefind/type/search_source_enum.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeApiServices _recipeApiServices = RecipeApiServices();

  //State untuk menyimpan hasil recipe random, dkk agar tidak fetch ulang lagi
  List<Recipe> _recommendationRecipes = [];
  List<Recipe> _randomRecipes = [];
  List<Recipe> _detailRecipe = [];
  Map<String, Recipe> _favoritedRecipes = {};

  // Ini menampung hasil data yang dcari oleh user
  List<Recipe> _searchResultRecipes = [];

  // Ini map menampung data hasil search yang pernah dilakukan user
  // Kita cache jaga2 jika ada request yang sama (sementara manual dlu) biar ga fetch lagi
  // Search bisa by name, kategori, main ingredients, dan area). Itu jadi key nya;
  Map<String, List<Recipe>> searchResultCache = {};

  List<Recipe> get recommendationRecipes => _recommendationRecipes;

  List<Recipe> get randomRecipes => _randomRecipes;

  List<Recipe> get searchResultRecipes => _searchResultRecipes;

  List<Recipe> get detailRecipe => _detailRecipe;

  Map<String, Recipe> get favoritedRecipes => _favoritedRecipes;

  //Loading State
  bool _isSearching = false;
  bool _isFetchingRandom = false;
  bool _isFetchingRecommendation = false;
  bool _isFetchingDetailRecipe = false;

  bool get isSearching => _isSearching;

  bool get isFetchingRandom => _isFetchingRandom;

  bool get isFetchingDetailRecipe => _isFetchingDetailRecipe;

  bool get isFetchingRecommendation => _isFetchingRecommendation;

  //Error state
  bool _isSearchingErr = false;
  bool _isDetailRecipeErr = false;
  bool _isRandomRecipeErr = false;
  bool _isRecommendationErr = false;

  bool get isSerchingErr => _isSearchingErr;

  bool get isDetailsRecipeErr => _isDetailRecipeErr;

  bool get isRandomRecipeErr => _isRandomRecipeErr;

  bool get isRecommendationErr => _isRecommendationErr;

  // Cari resep berdasarkan query user
  // Search source digunakan untuk menentukan apa link API
  // Query search bisa berasal dari searchBar, sarchByArea, dkk sehingga link berbeda
  Future<void> searchRecipe(String query, SearchSource source) async {
    _isSearchingErr = false;
    final normalQuery = query.trim().toLowerCase();

    if (searchResultCache.containsKey(normalQuery)) {
      _searchResultRecipes = searchResultCache[normalQuery]!;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchResultRecipes = [];
    notifyListeners();

    try {
      final response = await _recipeApiServices.searchRecipe(
        query: query,
        source: source,
      );
      _searchResultRecipes = response.meals;

      // bersihkan cache jika sudah terlalu banyak
      if (_searchResultRecipes.length > 30) {
        _searchResultRecipes.clear();
      }

      //Masukan data ke cache
      searchResultCache[normalQuery] = _searchResultRecipes;
    } catch (e) {
      _isSearchingErr = true;
      //Sementara print aja lah, nnti klo ada log masukin ke log
      print("Search Recipe Error: ${e.toString()}");
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> fetchRandomRecipes() async {
    //Random recipe hanya fetch sekali, jika sudah ada return. Supaya tidak fetch ulang
    _isRandomRecipeErr = false;

    if (_randomRecipes.isNotEmpty) {
      print('Random recipe sudah ada, tidak perlu fetch ulang');
      notifyListeners();
      return;
    }
    _isFetchingRandom = true;
    _randomRecipes = [];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      print('Random recipe fetch ulang');
      final response = await _recipeApiServices.getRecipe(count: 1);
      _randomRecipes = response.meals;
    } catch (e) {
      _isRandomRecipeErr = true;
      //Sementara print aja lah, nnti klo ada log masukin ke log
      print("Fetch Random Recipe Error: ${e.toString()}");
    } finally {
      _isFetchingRandom = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendationRecipes() async {
    _isRecommendationErr = false;

    //Fetch hanya sekali, jika sudah ada return. Supaya tidak fetch ulang
    if (_recommendationRecipes.isNotEmpty) {
      notifyListeners();
      return;
    }
    _isFetchingRecommendation = true;
    _recommendationRecipes = [];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final response = await _recipeApiServices.getRecipe(count: 10);
      _recommendationRecipes = response.meals;
    } catch (e) {
      _isRecommendationErr = true;
      //Sementara print aja lah, nnti klo ada log masukin ke log
      print("Fetch Recommendation Recipe Error: ${e.toString()}");
    } finally {
      _isFetchingRecommendation = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetailRecipes(String recipeId) async {
    _isDetailRecipeErr = false;

    //Fetch hanya sekali, jika sudah ada return. Supaya tidak fetch ulang
    if (_detailRecipe.isNotEmpty) {
      notifyListeners();
      return;
    }
    _isFetchingDetailRecipe = true;
    _detailRecipe = [];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final response = await _recipeApiServices.getRecipeById(id: recipeId);
      _detailRecipe = response.meals;
    } catch (e) {
      _isDetailRecipeErr = true;
      //Sementara print aja lah, nnti klo ada log masukin ke log
      print("Fetch Detail Recipe Error: ${e.toString()}");
    } finally {
      _isFetchingDetailRecipe = false;
      notifyListeners();
    }
  }

  void toggleFavoriteRecipe(String recipeId, Recipe recipe) {
    if (_favoritedRecipes.containsKey(recipeId)) {
      _favoritedRecipes.remove(recipeId);
    } else {
      final recipeEntries = <String, Recipe>{'$recipeId': recipe};
      _favoritedRecipes.addEntries(recipeEntries.entries);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  //Memberishkan
  void clearSearchResults() {
    _searchResultRecipes = [];
    _isSearchingErr = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  //Memberishkan
  void clearDetailRecipeData() {
    _detailRecipe = [];
    _isDetailRecipeErr = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
