import 'package:flutter/material.dart';
import 'package:flutter_foodiefind/app_bottom_navbar.dart';
import 'package:flutter_foodiefind/viewmodel/recipe_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    //Wrap App dengan provider agar bisa akses state
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecipeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //Supaya ukuran font tetap konsisten meskipun settingan ukuran font sistem berbeda
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: AppBottomNavbar(),
    );
  }
}
