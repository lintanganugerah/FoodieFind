import 'dart:convert';

class Recipe {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final Map<String, String?> ingredientsWithMeasures;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredientsWithMeasures,
  });

  //Jujur data API nya aneh. Ingredients dan measure terpisah, plus masing2 punya properti sendiri (bkn jadi array or smth)
  //Jadi disini for loop semua ingredients, beserta measurement. Data memang fixed hanya ada 20
  factory Recipe.fromJson(Map<String, dynamic> json) {
    Map<String, String?> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient = _parseString(json['strIngredient$i']);
      final measure = _parseString(json['strMeasure$i']);

      //Kalau tidak null jadikan satu ingredients beserta measurement nya
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients[ingredient] = (measure != null && measure.trim().isNotEmpty)
            ? measure.trim()
            : null;
      }
    }

    return Recipe(
      idMeal: _parseString(json['idMeal']) ?? '',
      strMeal: _parseString(json['strMeal']) ?? 'Unknown Meal',
      strCategory: _parseString(json['strCategory']),
      strArea: _parseString(json['strArea']),
      strInstructions: _parseString(json['strInstructions']),
      strMealThumb: _parseString(json['strMealThumb']),
      strTags: _parseString(json['strTags']),
      strYoutube: _parseString(json['strYoutube']),
      ingredientsWithMeasures: ingredients,
    );
  }
}

// Fungsi helper atau utils untuk parsing JSON
String? _parseString(dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return null;
  }
  return value.toString();
}

//Wrapper untuk mengolah data hasil response API
//Supaya hasil struktur aneh nya ini mudah di konsumsi
class RecipeResponse {
  final List<Recipe> meals;

  RecipeResponse({required this.meals});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    var mealsList = json['meals'] as List?;
    List<Recipe> recipes = mealsList != null
        ? mealsList
              .map((i) => Recipe.fromJson(i as Map<String, dynamic>))
              .toList()
        : [];
    return RecipeResponse(meals: recipes);
  }

  factory RecipeResponse.fromString(String str) =>
      RecipeResponse.fromJson(json.decode(str) as Map<String, dynamic>);
}
