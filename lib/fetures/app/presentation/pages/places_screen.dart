import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/fetures/app/domain/provider/user_place_provider.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/pages/places_add_screen.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  //====================================================================================================================
  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(
                      places: userPlaces,
                    ),
        ),
      ),
    );
  }
}
