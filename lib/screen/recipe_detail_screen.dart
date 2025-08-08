import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/card.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final List<int> _listItems = List.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Recipe',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        centerTitle: true,
        leading: BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 350.0,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      "https://placehold.co/200x1080/png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, 60),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CardContainer(
                      height: 150,
                      containerDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const BoldText(
                              text:
                                  'Greek Salad with Fresh Feta and Homemade Vinaigrette',
                              textAlignment: TextAlign.center,
                              textMaxline: 2,
                              textOverflow: TextOverflow.ellipsis,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tags, Category",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BoldText(
                    text: 'Ingredients',
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _listItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CardContainer(
                                  width: 100,
                                  containerPadd: EdgeInsets.zero,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      'https://placehold.co/1920x1080/png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              BoldText(
                                text: "Title",
                                textMaxline: 1,
                                color: Colors.black54,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Measurement",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const BoldText(
                    text: 'Instruction',
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  const Text("Deskripsi resep akan muncul di sini..."),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.green,
        label: Text("Youtube", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
