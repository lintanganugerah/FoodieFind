import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/card.dart';

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
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _listItems.length,
                  // Agar listview tidak terpotong
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 120,
                        height: 150,
                        child: CardContainer(
                          isShadow: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.fastfood_outlined, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                "Category ${index + 1}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _listItems.length,
                  // Agar listview tidak terpotong
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 120,
                        height: 150,
                        child: CardContainer(
                          isShadow: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.kitchen, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                "Main Ingredients ${index + 1}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                return SizedBox(
                  width: 120,
                  height: 150,
                  child: CardContainer(
                    isShadow: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.pin_drop, size: 40),
                        const SizedBox(height: 8),
                        Text("Area ${index + 1}", textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
