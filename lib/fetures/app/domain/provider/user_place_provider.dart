import 'dart:io';

import 'package:flutter_favorite_places/fetures/app/data/models/place_location_model.dart';
import 'package:flutter_favorite_places/fetures/app/data/models/place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}
//---------------------------------------------------------------------------------------------------------------------------

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  //TODO : Fetch Data
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lon'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  //TODO : Add Data
  void addPlace(String title, File image, PlaceLocation location) async {
    //ดึงที่อยู่ Dictory file
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //ชื่อไฟล์ 'path/image.png -> image.png'
    final fileName = path.basename(image.path);
    //image path 'appDir/image.png'
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    //Database
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lon': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

//============================================================================================================================
final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
