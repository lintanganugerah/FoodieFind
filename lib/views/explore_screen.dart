import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/constant/area_recipe_const.dart';
import 'package:flutter_foodiefind/constant/category_recipe_const.dart';
import 'package:flutter_foodiefind/constant/main_ingredients_recipe_const.dart';
import 'package:flutter_foodiefind/type/search_source_enum.dart';
import 'package:flutter_foodiefind/views/search_result_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/box_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const List<Map<String, String>> _categoriesData =
      CategoryRecipeConst.categoriesMap;
  static final int _categoriesDataLength = _categoriesData.length;

  static const List<Map<String, String>> _mainIngredientsData =
      MainIngredientsRecipeConst.mainIngredientsMap;
  static final int _mainIngredientsDataLength = _mainIngredientsData.length;

  static const List<Map<String, String>> _areaData =
      AreaRecipeConst.areaRecipeMap;
  static final int _areaDataLength = _areaData.length;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            //Section Explore By Category
            const BoldText(
              text: "Explore By Category",
              size: 16,
              color: Colors.green,
            ),

            //DIVIDER
            const SizedBox(height: 8),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _categoriesDataLength,
                itemBuilder: (BuildContext context, int index) {
                  final categories = _categoriesData.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: BoxCard(
                      imageAssets: categories["strCategoryThumb"],
                      titleOverlay: categories["strCategory"],
                      height: 120,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultScreen(
                              query: categories["strCategory"] ?? "",
                              searchFrom: SearchSource.category,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            //DIVIDER
            const SizedBox(height: 24),

            //Section Explore By Main Ingredients
            const BoldText(
              text: "Explore By Main Ingredients",
              size: 16,
              color: Colors.green,
            ),
            //DIVIDER
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _mainIngredientsDataLength,
                itemBuilder: (BuildContext context, int index) {
                  final mainIngr = _mainIngredientsData.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: BoxCard(
                      imageAssets: mainIngr['strIngredientThumb'],
                      titleOverlay: mainIngr['strIngredient'],
                      height: 120,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultScreen(
                              query: mainIngr['strIngredient'] ?? "",
                              searchFrom: SearchSource.mainIngredient,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            //DIVIDER
            const SizedBox(height: 24),

            //Section Explore By Area
            const BoldText(
              text: "Explore By Area",
              size: 16,
              color: Colors.green,
            ),
            //DIVIDER
            const SizedBox(height: 8),
            //Card By Area
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: _areaDataLength,
              clipBehavior: Clip.none,
              itemBuilder: (BuildContext context, int index) {
                final area = _areaData.elementAt(index);
                return BoxCard(
                  imageAssets: area["strAreaThumb"],
                  titleOverlay: area["strArea"],
                  height: 120,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                          query: area["strArea"] ?? "",
                          searchFrom: SearchSource.area,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
