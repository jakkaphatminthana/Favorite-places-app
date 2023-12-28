import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/fetures/app/data/models/place_model.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/pages/places_detail_screen.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.places,
  });

  final List<Place> places;

//=================================================================================================================
  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          //TODO 1.1: Image
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image),
          ),

          //TODO 1.2: Title
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          //TODO 1.3: Sub Title
          subtitle: Text(
            places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(place: places[index]),
              ),
            );
          },
        );
      },
    );
  }
}
