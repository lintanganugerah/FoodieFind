import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/views/search_result_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/box_card.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final List<int> _listItems = List.generate(10, (index) => index);

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
                itemCount: _listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: BoxCard(
                      imageUrl: "https://placehold.co/200x1080/png",
                      titleOverlay: "Category",
                      height: 120,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResultScreen(query: "Category"),
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

            //Section Explore By Main Ingreditens
            const BoldText(
              text: "Explore By Main Ingreditens",
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
                itemCount: _listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: BoxCard(
                      imageUrl: "https://placehold.co/200x1080/png",
                      titleOverlay: "Main Ingredients ${index + 1}",
                      height: 120,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResultScreen(query: "Main Ingredients"),
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
              itemCount: _listItems.length,
              clipBehavior: Clip.none,
              itemBuilder: (BuildContext context, int index) {
                return BoxCard(
                  imageUrl: "https://placehold.co/200x1080/png",
                  titleOverlay: "Area ${index + 1}",
                  height: 120,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultScreen(query: "Area"),
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
