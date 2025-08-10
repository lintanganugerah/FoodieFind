import 'package:dio/dio.dart';
import 'package:flutter_foodiefind/models/network/dio_client.dart';
import 'package:flutter_foodiefind/models/recipe_model.dart';

Future<RecipeResponse> fetchDataGet({required String url}) async {
  final Dio dio = DioClient.instance;
  final response = await dio.get(url);

  if (response.statusCode == 200) {
    if (response.data == null) {
      return RecipeResponse(meals: []);
    }
    return RecipeResponse.fromJson(response.data);
  } else {
    throw Exception(
      'Failed to load recipes (status code: ${response.statusCode})',
    );
  }
}

class RecipeApiServices {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  //Cari resep berdasarkan kata kunci
  Future<RecipeResponse> searchRecipe({String query = ''}) async {
    final url = "$_baseUrl/search.php?s=$query";
    try {
      return await fetchDataGet(url: url);
    } catch (e) {
      throw Exception("Something Went Wrong: $e");
    }
  }

  //Ambil satu atau lebih resep (random)
  Future<RecipeResponse> getRecipe({int count = 1}) async {
    final url = "$_baseUrl/random.php";
    List<Recipe> dataBucket = [];

    //Kasih limit sendiri supaya gak banjir
    if (count > 10) {
      throw Exception("Max getRecipe limit is 10");
    }

    try {
      //Sejauh ini tidak ada limiter jadi ini aman
      for (int i = 0; i < count; i++) {
        final response = await fetchDataGet(url: url);
        dataBucket.addAll(response.meals);
      }
      return RecipeResponse(meals: dataBucket);
    } catch (e) {
      throw Exception("Something Went Wrong: $e");
    }
  }

  //Ambil resep berdasarkan id
  Future<RecipeResponse> getRecipeById({String id = ''}) async {
    final url = "$_baseUrl/lookup.php?i=$id";
    try {
      return await fetchDataGet(url: url);
    } catch (e) {
      throw Exception("Something Went Wrong: $e");
    }
  }

  Future<RecipeResponse> getRecipeByIngredient({String ingredient = ''}) async {
    final url = "$_baseUrl/filter.php?i=$ingredient";
    try {
      return await fetchDataGet(url: url);
    } catch (e) {
      throw Exception("Something Went Wrong: $e");
    }
  }
}
