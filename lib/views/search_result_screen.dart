import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/recipe_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final bool isFromSearchBar;

  const SearchResultScreen({
    super.key,
    required this.query,
    this.isFromSearchBar = false,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final List<int> _listItems = List.generate(6, (int index) => 1 + index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BoldText(text: "Result", size: 16),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isFromSearchBar
                    ? Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldText(text: "You Searched for:", size: 16),
                            SizedBox(width: 8),
                            Text(widget.query),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _listItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.70,
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
          ),
        ),
      ),
    );
  }
}
