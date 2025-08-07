import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/widgets/bold_text.dart';
import 'package:flutter_foodiefind/widgets/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                  Colors.green.withValues(alpha: 0.7), // Starting color
                  Colors.white, // Ending color
                ],
                stops: [0.0, 0.5],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoldText(text: 'Feeling Hungry?', size: 20),
                const BoldText(text: "What are we cooking today?", size: 20),
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
                    const Text("Pilihan Acak Hari Ini"),
                    Row(
                      children: [
                        Expanded(
                          child: CardContainer(
                            isShadow: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [const Text("A")],
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
                        const Text("Rekomendasi"),
                        const Text("See All"),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 12,
                      children: [
                        CardContainer(
                          isShadow: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [const Text("A")],
                          ),
                        ),
                      ],
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
