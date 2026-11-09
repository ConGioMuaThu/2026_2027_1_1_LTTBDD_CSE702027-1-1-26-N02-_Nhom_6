import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/repositories/plant_repository.dart';

class PlantProvider extends ChangeNotifier {
  PlantProvider({
    required Locale locale,
    PlantRepository? repository,
  })  : _locale = locale,
        _repository = repository ?? PlantRepository() {
    _plants = _repository.initialPlants(locale);
  }

  final PlantRepository _repository;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  late List<Plant> _plants;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<Plant> get plants => UnmodifiableListView(_plants);

  List<String> get plantNames => _repository.plantNames(_plants);

  Plant? findById(String id) => _repository.findById(_plants, id);

  Future<void> load() async {
    _loading = true;

    try {
      final saved = await _repository.loadPlants();
      if (_disposed) return;
      if (saved != null) _plants = _repository.localize(saved, _locale);
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (!_disposed) notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _plants = _repository.localize(_plants, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    _run(() {
      final index = _plants.indexWhere((p) => p.id == id);
      if (index == -1) return;

      _plants[index] = _repository.copyWith(
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

  void update(Plant plant) {
    _run(() {
      final index = _plants.indexWhere((p) => p.id == plant.id);
      if (index == -1) return;

      _plants[index] = plant;
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
    _repository.savePlants(_plants);
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}