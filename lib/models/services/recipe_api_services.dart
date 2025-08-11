import 'package:dio/dio.dart';
import 'package:flutter_foodiefind/constant/api_const.dart';
import 'package:flutter_foodiefind/models/network/dio_client.dart';
import 'package:flutter_foodiefind/models/recipe_model.dart';
import 'package:flutter_foodiefind/type/search_source_enum.dart';

Future<RecipeResponse> fetchDataGet({required String url, int? maxData}) async {
  final Dio dio = DioClient.instance;
  final response = await dio.get(url);

  if (response.statusCode == 200) {
    if (response.data == null) {
      return RecipeResponse(meals: []);
    }
    if (maxData != null && maxData > 0) {
      return RecipeResponse.fromJson(response.data, maxData);
    }
    return RecipeResponse.fromJson(response.data);
  } else {
    throw Exception(
      'Failed to load recipes (status code: ${response.statusCode})',
    );
  }
}

String _normalizedParams({required String param}) {
  return param.replaceAll(' ', '_').toLowerCase();
}

class RecipeApiServices {
  static const String _baseUrl = ApiConst.baseUrl;

  //Cari resep berdasarkan kata kunci
  Future<RecipeResponse> searchRecipe({
    required String query,
    required SearchSource source,
  }) async {
    late String url;

    switch (source) {
      case SearchSource.searchBar:
        url = "$_baseUrl/search.php?s=$query";
        break;
      case SearchSource.category:
        url = "$_baseUrl/filter.php?c=${_normalizedParams(param: query)}";
        break;
      case SearchSource.mainIngredient:
        url = "$_baseUrl/filter.php?i=${_normalizedParams(param: query)}";
        break;
      case SearchSource.area:
        url = "$_baseUrl/filter.php?a=${_normalizedParams(param: query)}";
        break;
    }

    try {
      return await fetchDataGet(url: url, maxData: 30);
    } catch (e) {
      throw Exception("Something Went Wrong: $e");
    }
  }

  //Ambil satu atau lebih resep (random)
  Future<RecipeResponse> getRecipe({int count = 1}) async {
    final url = "$_baseUrl/random.php";

    //Kasih limit sendiri supaya gak banjir
    if (count > 10) {
      throw Exception("Max getRecipe limit is 10");
    }

    try {
      // Tidak ada API untuk ambil data secara bulk, sehingga harus melakukan banyak request
      // Sejauh ini aman karena tidak ada limiter dari API server
      // Generate list banyaknya API Call yang harus dilakukan berdasarkan count
      final apiCalls = List.generate(count, (_) => fetchDataGet(url: url));

      // Paralel ApiCall
      final responses = await Future.wait(apiCalls);

      // Gabungkan semua hasil menjadi satu list
      final List<Recipe> dataBucket = [];
      for (var response in responses) {
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
