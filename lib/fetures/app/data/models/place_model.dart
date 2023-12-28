import 'dart:io';
import 'package:flutter_favorite_places/fetures/app/data/models/place_location_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}
