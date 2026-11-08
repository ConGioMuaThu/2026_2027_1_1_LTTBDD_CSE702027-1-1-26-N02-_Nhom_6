import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/services/storage_service.dart';

class PlantProvider extends ChangeNotifier {
  PlantProvider({
    required Locale locale,
    StorageService? storage,
  })  : _locale = locale,
        _storage = storage ?? StorageService.instance,
        _plants = samplePlantsFor(locale);

  final StorageService _storage;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  List<Plant> _plants;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<Plant> get plants => UnmodifiableListView(_plants);

  List<String> get plantNames => _plants.map((p) => p.name).toList();

  Future<void> load() async {
    _loading = true;

    try {
      final saved = await _storage.loadPlants();
      if (_disposed) return;
      if (saved != null) _plants = _localized(saved, _locale);
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (!_disposed) notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _plants = _localized(_plants, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    _run(() {
      final index = _plants.indexWhere((p) => p.id == id);
      if (index == -1) return;

      _plants[index] = _copyWith(
        _plants[index],
        isFavorite: !_plants[index].isFavorite,
      );
      _persist();
      notifyListeners();
    });
  }

  void add(Plant plant) {
    _run(() {
      _plants.insert(0, plant);
      _persist();
      notifyListeners();
    });
  }

  void remove(String id) {
    _run(() {
      _plants.removeWhere((p) => p.id == id);
      _persist();
      notifyListeners();
    });
  }

  void _run(VoidCallback action) {
    if (_loading) {
      _pending.add(action);
    } else {
      action();
    }
  }

  void _flushPending() {
    final queued = List<VoidCallback>.of(_pending);
    _pending.clear();
    for (final action in queued) {
      action();
    }
  }

  void _persist() {
    _storage.savePlants(_plants);
  }

  List<Plant> _localized(List<Plant> source, Locale locale) {
    final fresh = {
      for (final plant in samplePlantsFor(locale)) plant.id: plant,
    };

    return [
      for (final plant in source)
        fresh.containsKey(plant.id)
            ? _copyWith(fresh[plant.id]!, isFavorite: plant.isFavorite)
            : plant,
    ];
  }

  Plant _copyWith(Plant plant, {required bool isFavorite}) {
    return Plant(
      id: plant.id,
      name: plant.name,
      scientificName: plant.scientificName,
      category: plant.category,
      description: plant.description,
      careLevel: plant.careLevel,
      waterNeed: plant.waterNeed,
      sunlight: plant.sunlight,
      imageAsset: plant.imageAsset,
      imageUrl: plant.imageUrl,
      isFavorite: isFavorite,
      tags: plant.tags,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}