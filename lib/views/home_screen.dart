import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/views/recipe_detail_screen.dart';
import 'package:flutter_foodiefind/views/search_result_screen.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/card.dart';
import 'package:flutter_foodiefind/widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _listItems = List.generate(6, (int index) => 1 + index);

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      print('Mencari untuk: "$searchQuery"');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchResultScreen(query: searchQuery, isFromSearchBar: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lengthListItems = _listItems.length;
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
                //Random Pick Of the day section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const BoldText(
                      text: "Pilihan Acak Hari Ini",
                      size: 16,
                      color: Colors.green,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CardContainer(
                            containerPadd: EdgeInsets.zero,
                            containerDecoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://placehold.co/200x1080/png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.withValues(alpha: 0.05),
                                    Colors.green.withValues(alpha: 0.3),
                                  ],
                                  stops: [0.1, 0.8],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const BoldText(
                                    text: "ASDADASDSADA",
                                    size: 16,
                                    color: Colors.white,
                                    textAlignment: TextAlign.center,
                                    textMaxline: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    "Text",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //DIVIDER
                SizedBox(height: 16),
                //Rekomendasi Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const BoldText(
                      text: "Rekomendasi",
                      color: Colors.green,
                      size: 16,
                    ),
                    GridView.builder(
                      itemCount: lengthListItems,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.70,
                          ),
                      itemBuilder: (context, index) {
                        final item = _listItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(),
                              ),
                            );
                          },
                          child: RecipeCard(
                            title: "Title $item",
                            subtitle: "Subtitle",
                            imageNetworkUrl:
                                "https://placehold.co/1920x1080/png",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
