import 'package:flutter/widgets.dart' show Locale;
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/services/storage_service.dart';

class PlantRepository {
  PlantRepository({StorageService? storage})
      : _storage = storage ?? StorageService.instance;

  final StorageService _storage;

  List<Plant> initialPlants(Locale locale) => samplePlantsFor(locale);

  Future<List<Plant>?> loadPlants() => _storage.loadPlants();

  Future<void> savePlants(List<Plant> plants) => _storage.savePlants(plants);

  Plant? findById(List<Plant> plants, String id) {
    for (final plant in plants) {
      if (plant.id == id) return plant;
    }
    return null;
  }

  List<Plant> favorites(List<Plant> plants) {
    return plants.where((plant) => plant.isFavorite).toList();
  }

  List<String> plantNames(List<Plant> plants) {
    return plants.map((plant) => plant.name).toList();
  }

  Plant copyWith(Plant plant, {String? name, bool? isFavorite}) {
    return Plant(
      id: plant.id,
      name: name ?? plant.name,
      scientificName: plant.scientificName,
      category: plant.category,
      description: plant.description,
      careLevel: plant.careLevel,
      waterNeed: plant.waterNeed,
      sunlight: plant.sunlight,
      imageAsset: plant.imageAsset,
      imageUrl: plant.imageUrl,
      isFavorite: isFavorite ?? plant.isFavorite,
      tags: plant.tags,
    );
  }

  bool isUntouchedSample(Plant plant) {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final sample in samplePlantsFor(locale)) {
        if (sample.id == plant.id &&
            sample.name == plant.name &&
            sample.scientificName == plant.scientificName &&
            sample.category == plant.category &&
            sample.description == plant.description &&
            sample.careLevel == plant.careLevel &&
            sample.waterNeed == plant.waterNeed &&
            sample.sunlight == plant.sunlight &&
            sample.imageAsset == plant.imageAsset &&
            sample.imageUrl == plant.imageUrl) {
          return true;
        }
      }
    }
    return false;
  }

  List<Plant> localize(List<Plant> source, Locale locale) {
    final fresh = {
      for (final plant in samplePlantsFor(locale)) plant.id: plant,
    };

    return [
      for (final plant in source)
        fresh.containsKey(plant.id) && isUntouchedSample(plant)
            ? copyWith(fresh[plant.id]!, isFavorite: plant.isFavorite)
            : plant,
    ];
  }
}