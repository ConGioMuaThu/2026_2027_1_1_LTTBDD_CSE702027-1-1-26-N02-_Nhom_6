import 'package:flutter/material.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/my_plants/add_plant_screen.dart';

class EditPlantScreen extends StatelessWidget {
  const EditPlantScreen({
    super.key,
    required this.plant,
    this.existingNames = const [],
  });

  final Plant plant;
  final List<String> existingNames;

  @override
  Widget build(BuildContext context) {
    return AddPlantScreen(
      initialPlant: plant,
      existingNames: existingNames,
    );
  }
}