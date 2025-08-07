import 'package:flutter/material.dart';
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
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(24),
                    color: Colors.white,
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
                                  'https://placehold.co/400x600/png',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BoldText(
                          text: "Rekomendasi",
                          color: Colors.green,
                          size: 16,
                        ),
                        const Text("See All", style: TextStyle(fontSize: 12)),
                      ],
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
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final item = _listItems[index];
                        return RecipeCard(
                          title: "Title $item",
                          subtitle: "Subtitle",
                          imageNetworkUrl: "https://placehold.co/1920x1080/png",
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
