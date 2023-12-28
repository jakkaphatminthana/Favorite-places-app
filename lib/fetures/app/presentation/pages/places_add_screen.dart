import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/fetures/app/data/models/place_location_model.dart';
import 'package:flutter_favorite_places/fetures/app/domain/provider/user_place_provider.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/widgets/image_input.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  //TODO : Save data
  void _savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    //Save Data provider
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredText, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

//==============================================================================================================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                //TODO : title Input
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 10),

                //TODO : Image Input
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(height: 10),

                //TODO : Location Input
                LocationInput(
                  onSelectLocation: (location) {
                    _selectedLocation = location;
                  },
                ),

                const SizedBox(height: 16),
                //TODO : Button
                ElevatedButton.icon(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
