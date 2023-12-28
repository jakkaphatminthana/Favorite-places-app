import 'package:flutter/material.dart';

TextStyle titleMedium_White(BuildContext context) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      );
}
