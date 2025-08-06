import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/components/bold_text.dart';
import 'package:flutter_foodiefind/components/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(24),
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text("Rekomendasi"), const Text("See All")],
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
    );
  }
}
