// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_foodiefind/models/recipe_model.dart';
import 'package:flutter_foodiefind/models/services/recipe_api_services.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeApiServices _recipeApiServices = RecipeApiServices();

  //State untuk menyimpan hasil recipe random, dkk agar tidak fetch ulang lagi
  List<Recipe> _recommendationRecipes = [];
  List<Recipe> _randomRecipes = [];
  Recipe? _selectedRecipe;
  List<Recipe> _favoritedRecipes = [];

  // Ini menampung hasil data yang dcari oleh user
  List<Recipe> _searchResultRecipes = [];

  // Ini map menampung data hasil search yang pernah dilakukan user
  // Kita cache jaga2 jika ada request yang sama (sementara manual dlu) biar ga fetch lagi
  // Search bisa by name, kategori, main ingredients, dan area). Itu jadi key nya;
  Map<String, List<Recipe>> searchResultCache = {};

  List<Recipe> get recommendationRecipes => _recommendationRecipes;

  List<Recipe> get randomRecipes => _randomRecipes;

  List<Recipe> get searchResultRecipes => _searchResultRecipes;

  Recipe? get selectedRecipe => _selectedRecipe;

  List<Recipe> get favoritedRecipes => _favoritedRecipes;

  //Loading State
  bool _isSearching = false;
  bool _isFetchingRandom = false;
  bool _isFetchingRecommendation = false;
  bool _isFetchingDetails = false;

  bool get isSearching => _isSearching;

  bool get isFetchingRandom => _isFetchingRandom;

  bool get isFetchingDetails => _isFetchingDetails;

  bool get isFetchingRecommendation => _isFetchingRecommendation;

  //Error state
  bool _isSearchingErr = false;
  bool _isDetailsErr = false;
  bool _isRandomRecipeErr = false;
  bool _isRecommendationErr = false;

  bool get isSerchingErr => _isSearchingErr;

  bool get isDetailsErr => _isDetailsErr;

  bool get isRandomRecipeErr => _isRandomRecipeErr;

  bool get isRecommendationErr => _isRecommendationErr;

  Future<void> searchRecipe(String query) async {
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
      final response = await _recipeApiServices.searchRecipe(query: query);
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> fetchRecommendationRecipes() async {
    _isRecommendationErr = false;

    //Fetch hanya sekali, jika sudah ada return. Supaya tidak fetch ulang
    if (_recommendationRecipes.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  //Memberishkan
  void clearSearchResults() {
    _searchResultRecipes = [];
    _isSearchingErr = false;
  }
}
