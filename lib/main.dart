import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/pages/places_screen.dart';
import 'package:flutter_favorite_places/resource/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const PlaceScreen(),
    );
  }
}
